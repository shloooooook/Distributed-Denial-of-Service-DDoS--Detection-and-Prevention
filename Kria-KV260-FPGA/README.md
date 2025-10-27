# Approach 3: FPGA Hardware Acceleration

This directory contains the files related to the real-time DDoS detection system implemented on a Xilinx Kria KV260 FPGA. This approach offloads the packet inspection process to hardware, allowing for high-throughput, low-latency detection that is not possible with a purely software-based solution.

## 📂 Files in this Directory

* **`fpga_detector.py`**: A Python script designed to run on the Kria KV260's ARM processor using the PYNQ framework. It uses the `scapy` library to sniff network packets from the FPGA's Ethernet interface and implements a simple threshold-based detection algorithm.

## ⚙️ How It Works

1.  **Hardware Logic (FPGA):** The FPGA is programmed with a hardware design (created in Vivado) that includes an IP block for network packet processing. This design handles the low-level task of receiving Ethernet frames.
2.  **Software Logic (Python/PYNQ):** The `fpga_detector.py` script runs on the Zynq MPSoC's ARM processor.
    * It uses **Scapy**, a powerful packet manipulation library, to listen to the network interface (`end0` in the script).
    * The `monitor` function inspects each packet in real-time.
    * If a packet is a TCP packet with only the SYN flag set (`pkt[TCP].flags == "S"`), it's identified as a potential attack packet and a counter (`syn_count`) is incremented.
    * If the counter exceeds a defined `SYN_THRESHOLD`, an alert is printed to the console, indicating a likely SYN flood attack.

## 🚀 How to Run

### Dependencies
This script requires the `scapy` library. You can install it on your Kria board (or any Linux system with `pip`) from the requirements.txt file 
> ![Requirements.txt](requirements.txt)