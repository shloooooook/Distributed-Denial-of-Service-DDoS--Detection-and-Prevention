# Approach 1: Custom Firewall for DDoS Mitigation

This directory contains the `rules.before` file for UFW (Uncomplicated Firewall) on Ubuntu. The rules are designed to create a robust, layered defense against network-based attacks, specifically targeting the SSH service (port 22) with a focus on mitigating SYN flood DDoS attacks.

## 🛡️ Defense Strategy Overview

The firewall employs a multi-layered strategy to filter traffic. Instead of a single rule, it uses a sequence of checks to progressively weed out malicious packets, ensuring that the SSH server is protected from overwhelming traffic while still allowing legitimate connections.
The primary defense mechanisms are **SYNPROXY**, **Rate Limiting**, and **Connection Tracking Optimization**.

## 🔧 Key Features Explained
### 1. Connection Tracking Optimization (`--notrack`)
*raw -A PREROUTING -i enp0s8 -s 10.0.2.0/28 -p tcp --syn --dport 22 -j CT --notrack
**Purpose:** This rule provides a "fast path" for trusted traffic. It tells the firewall *not* to waste resources tracking connections originating from the specified trusted IP range (`10.0.2.0/28`).

### 2. Core SYN Flood Defense (`SYNPROXY`)
-A ufw-before-input -i enp0s8 -p tcp --dport 22 -m conntrack --ctstate NEW -j SYNPROXY ...
**Purpose:** This is the primary defense against SYN flood attacks. Instead of passing new connection requests (SYN packets) directly to the SSH server, the firewall intercepts them.
**How it Works:** The firewall itself completes the three-way TCP handshake with the client. If the client is legitimate, it will complete the handshake. Only then does the firewall establish a real connection to the protected SSH server. Attack packets (which never complete the handshake) are dropped by the firewall, never reaching and overwhelming the server.

### 3. Rate Limiting (`hashlimit` & `connlimit`)
-A ufw-before-input -p tcp --dport 22 -m connlimit --connlimit-above 20 ... -j REJECT -A ufw-before-input -p tcp --dport 22 -m conntrack --ctstate NEW -m hashlimit ... -j DROP


**Purpose:** These rules act as a secondary defense layer to control the volume of traffic from any single IP address.
**`hashlimit`:** This rule limits the rate of *new* connection attempts. In this configuration, it drops an IP if it tries to open more than 5 new SSH connections per second.
**`connlimit`:** This rule limits the total number of *simultaneously active* connections from a single IP address to 20.

### 4. Firewall Hygiene (Basic Security)
**Drop Invalid Packets:** Any packets that don't belong to a known connection are immediately dropped.
**Block Malformed Packets:** Packets with nonsensical TCP flags (e.g., all flags on, no flags on) are blocked.
**Enforce Correct Handshake:** Ensures that any new TCP connection begins with a SYN packet.

## ⚙️ Configuration

To adapt these rules for your own environment, you would need to modify the following:
**`enp0s8`**: This is the name of the network interface being protected. You can find your interface name by running the `ip a` command.
**`10.0.2.0/28`**: This is the IP address range of the trusted "management" network that is allowed to bypass connection tracking.
**`--dport 22`**: This is the port being protected (22 for SSH). This could be changed to protect other services like a web server (port 80/443).

## 🚀 How to Implement

1.  **Backup your existing rules:**
    ```bash
    sudo cp /etc/ufw/before.rules /etc/ufw/before.rules.bak
    ```
2.  **Replace the file:** Copy the contents of this project's `before.rules` file into `/etc/ufw/before.rules` on your Ubuntu machine.
    ```bash
    sudo cp ./rules.before /etc/ufw/before.rules
    ```
3.  **Reload the firewall** to apply the new rules:
    ```bash
    sudo ufw reload
    ```