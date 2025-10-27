from scapy.all import sniff, TCP

# Use the Kria Ethernet interface
iface = 'end0'

# Threshold for alerting
SYN_THRESHOLD = 50
syn_count = 0

def monitor(pkt):
    global syn_count
    if TCP in pkt and pkt[TCP].flags == "S":
        syn_count += 1
        print(f"SYN packet detected! Count: {syn_count}")
        if syn_count >= SYN_THRESHOLD:
            print("ALERT: SYN threshold exceeded! Possible SYN flood attack!")
            # Optionally reset counter after alert
            syn_count = 0

# Start sniffing packets
print(f"Monitoring SYN packets on {iface}...")
sniff(iface=iface, prn=monitor, store=False)