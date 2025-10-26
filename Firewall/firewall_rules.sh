#
# rules.before
#
# Rules that should be run before the ufw command line added rules. Custom
# rules should be added to one of these chains:
#   ufw-before-input
#   ufw-before-output
#   ufw-before-forward
#

# Don't delete these required lines, otherwise there will be errors
*raw
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

-A PREROUTING -i enp0s8 -s 10.0.2.0/28 -p tcp --syn --dport 22 -j CT --notrack
COMMIT

*filter
:ufw-before-input - [0:0]
:ufw-before-output - [0:0]
:ufw-before-forward - [0:0]
:ufw-not-local - [0:0]
# End required lines

# allow all on loopback
-A ufw-before-input -i lo -j ACCEPT
-A ufw-before-output -o lo -j ACCEPT
# Drop junk early (nonsense flags,invalid-states)
-A ufw-before-input -m conntrack --ctstate INVALID -j DROP
-A ufw-before-input -p tcp --tcp-flags ALL NONE -j DROP
-A ufw-before-input -p tcp --tcp-flags ALL ALL -j DROP
# New tcp must start with SYN
-A ufw-before-input -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
-A ufw-before-input -i enp0s8 -p tcp --dport 22 -m conntrack --ctstate NEW ! -s 10.0.2.0/28 -j DROP
# SYNPROXY: complete TCP handshake on behalf of the service
# Only real clients (who finish the handshake) ever reach sshd.
-A ufw-before-input -i enp0s8 -p tcp --dport 22 -m conntrack --ctstate NEW -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
# Optional mild per‑IP protections for SSH after handshake
-A ufw-before-input -p tcp --dport 22 -m connlimit --connlimit-above 20 --connlimit-mask 32 -j REJECT --reject-with tcp-reset
#Limit new connection rate per ip
-A ufw-before-input -p tcp --dport 22 -m conntrack --ctstate NEW -m hashlimit --hashlimit-name ssh-new --hashlimit-above 5/second --hashlimit-burst 20 --hashlimit-mode srcip --hashlimit-htable-expire 300000 -j DROP
#global syn gate for ssh
:ufw-synflood-22 - [0:0]
-A ufw-synflood-22 -m limit --limit 100/second --limit-burst 200 -j RETURN
-A ufw-synflood-22 -j DROP
-A ufw-before-input -i enp0s8 -p tcp --syn --dport 22 -j ufw-synflood-22

# quickly process packets for which we already have a connection
-A ufw-before-input -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A ufw-before-output -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A ufw-before-forward -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# drop INVALID packets (logs these in loglevel medium and higher)
-A ufw-before-input -m conntrack --ctstate INVALID -j ufw-logging-deny
-A ufw-before-input -m conntrack --ctstate INVALID -j DROP

# ok icmp codes for INPUT
-A ufw-before-input -p icmp --icmp-type destination-unreachable -j ACCEPT
-A ufw-before-input -p icmp --icmp-type time-exceeded -j ACCEPT
-A ufw-before-input -p icmp --icmp-type parameter-problem -j ACCEPT
-A ufw-before-input -p icmp --icmp-type echo-request -j ACCEPT

# ok icmp code for FORWARD
-A ufw-before-forward -p icmp --icmp-type destination-unreachable -j ACCEPT
-A ufw-before-forward -p icmp --icmp-type time-exceeded -j ACCEPT
-A ufw-before-forward -p icmp --icmp-type parameter-problem -j ACCEPT
-A ufw-before-forward -p icmp --icmp-type echo-request -j ACCEPT

# allow dhcp client to work
-A ufw-before-input -p udp --sport 67 --dport 68 -j ACCEPT

#
# ufw-not-local
#
-A ufw-before-input -j ufw-not-local

# if LOCAL, RETURN
-A ufw-not-local -m addrtype --dst-type LOCAL -j RETURN

# if MULTICAST, RETURN
-A ufw-not-local -m addrtype --dst-type MULTICAST -j RETURN

# if BROADCAST, RETURN
-A ufw-not-local -m addrtype --dst-type BROADCAST -j RETURN

# all other non-local packets are dropped
-A ufw-not-local -m limit --limit 3/min --limit-burst 10 -j ufw-logging-deny
-A ufw-not-local -j DROP

# allow MULTICAST mDNS for service discovery (be sure the MULTICAST line above
# is uncommented)
-A ufw-before-input -p udp -d 224.0.0.251 --dport 5353 -j ACCEPT

# allow MULTICAST UPnP for service discovery (be sure the MULTICAST line above
# is uncommented)
-A ufw-before-input -p udp -d 239.255.255.250 --dport 1900 -j ACCEPT

# don't delete the 'COMMIT' line or these rules won't be processed
COMMIT