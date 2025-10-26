# DDoS Detection and Mitigation System

This repository contains the source code for my final year project, which explores three distinct approaches for detecting and mitigating Distributed Denial of Service (DDoS) attacks.

## 🚀 Project Overview

The goal of this project was to implement and evaluate different strategies for protecting a network from DDoS attacks. Three methods were developed:

1.  **A Custom Stateful Firewall:** A rule-based system for blocking malicious traffic patterns.
2.  **A Machine Learning Classifier:** A model trained on the CIC-DDoS2019 dataset to identify attack traffic based on network features.
3.  **An FPGA-based Hardware Accelerator:** A system leveraging the Kria KV260 FPGA to perform high-speed packet inspection.

## 📂 Repository Structure
This project is divided into three main folders, each containing a self-contained implementation of one of the approaches.

### [1. Custom Firewall Approach](./1-firewall-approach/)
This approach uses `iptables` and Python scripting to create a stateful firewall that identifies and blocks common DDoS patterns like SYN floods.

* **Tech Stack:** Python, Scapy, Netfilter/iptables, Linux networking
* **Go to this folder for setup and execution instructions.**

### [2. Machine Learning Approach](./2-ml-approach/)
This approach uses a machine learning model to classify network traffic as either benign or malicious. The model was trained on the CIC-DDoS2019 dataset.

* **Tech Stack:** Python, TensorFlow/Keras, Scikit-learn, Pandas, CIC-DDoS2019
* **Go to this folder for setup and execution instructions.**

### [3. FPGA Hardware Acceleration Approach](./3-fpga-approach/)
This approach offloads the detection logic to a Xilinx Kria KV260 FPGA for high-throughput, low-latency packet analysis.

* **Tech Stack:** PYNQ (Python Productivity for Zynq), VHDL/Verilog (or HLS), Xilinx Vivado
* **Go to this folder for setup and execution instructions.**

---

## 👥 Team Members
* [Shlok Yadav]
* [Prachi Sankhe]
* [Ayeshna Singh]# Distributed-Denial-of-Service-DDoS--Detection-and-Prevention
# Distributed-Denial-of-Service-DDoS--Detection-and-Prevention
