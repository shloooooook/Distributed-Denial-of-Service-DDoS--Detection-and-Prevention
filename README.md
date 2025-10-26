# Distributed Denial of Service (DDoS) Detection and Mitigation System

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.9+](https://img.shields.io/badge/Python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![Scikit-learn](https://img.shields.io/badge/Scikit--learn-orange)](https://scikit-learn.org/stable/)
[![Xilinx](https://img.shields.io/badge/Xilinx-FPGA-red)](https://www.xilinx.com/)

This repository contains the source code for our final year project, which explores three distinct approaches for detecting and mitigating Distributed Denial of Service (DDoS) attacks.

---

## 🚀 Project Overview

The goal of this project was to implement and evaluate different strategies for protecting a network from DDoS attacks. Three methods were developed:

1.  **A Custom Stateful Firewall:** A rule-based system using `iptables` for blocking malicious traffic patterns at the network level.
2.  **A Machine Learning Classifier:** A `RandomForestClassifier` trained on the CIC-DDoS2019 dataset to identify attack traffic based on statistical flow features.
3.  **An FPGA-based Hardware Accelerator:** A system leveraging the Kria KV260 FPGA to perform high-speed, low-latency packet inspection in hardware.

---

## 📈 Key Results & Demonstrations

This section highlights the key outcomes and performance metrics from each of the three implemented approaches.

### 1. Custom Firewall Approach: Visualizing a DDoS Attack

The firewall's primary role is to protect the server from being overwhelmed by traffic. The graphs below show the network state of a server without protection.

> **Idle Network State:** This is the baseline performance of the server under normal conditions, with minimal network traffic.
>
> ![Idle Network Traffic](idle_network.png)
>
> **Network Under SYN Flood Attack:** This graph shows the same server during a simulated SYN flood attack. The massive spike in **upload traffic (red line)** is the server attempting to send SYN-ACK responses to thousands of spoofed IP addresses, quickly consuming its bandwidth and resources. The goal of our custom firewall rules is to prevent this scenario.
>
> ![Network Under Attack](network_under_attack.png)

---

### 2. Machine Learning Approach: High-Accuracy Classification

This approach focused on building a highly accurate and reliable classifier. After handling a severe class imbalance in the training data, we optimized the model's decision threshold to maximize its F1-Score.

> **Optimal Threshold Analysis:** This graph shows how we determined the optimal decision threshold for our model. The threshold of **0.09** provides the best balance between Precision (correctly identifying attacks) and Recall (catching as many attacks as possible), maximizing the F1-Score.
>
> ![Precision-Recall Curve](graph.png)
>
> **Final Confusion Matrix:** The final model, using the optimal threshold, is exceptionally accurate. The results on the test set show:
> * **True Negatives (Benign):** 6,066 samples correctly identified as benign.
> * **False Positives (Benign Blocked):** Only **4** benign samples were incorrectly classified as attacks.
> * **False Negatives (Attacks Missed):** Only **3** attack samples were missed.
> * **True Positives (Attacks Caught):** 255,761 attack samples were correctly identified.
>
> This demonstrates a highly reliable model suitable for deployment.
>
> ![Final Confusion Matrix](conf2.png)

---

### 3. FPGA Hardware Acceleration Approach: Real-Time Detection

This approach offloads the detection logic to hardware for line-rate processing speed, which is impossible to achieve in software.

> **Hardware Architecture:** This is the block diagram of our detection system, designed in Xilinx Vivado. The core of the system is the **Zynq UltraScale+ MPSoC**, which processes incoming network packets. Our custom `syn_v1.0` IP block is responsible for identifying SYN packets.
>
> ![Vivado Block Diagram](HW_Vivado_BD.png)
>
> **Live Attack Detection:** This screenshot demonstrates the system in action.
> * **Top Window (Attacker):** The `hping3` tool is used to launch a SYN flood attack against the FPGA board.
> * **Bottom Window (FPGA Detector):** The PYNQ-based system running on the Kria KV260 board instantly detects the incoming SYN packets, increments a counter, and raises an alert (`Possible SYN flood attack!`) once a threshold is exceeded. This proves the viability of real-time, hardware-accelerated DDoS detection.
>
> ![Live FPGA Detection](Basic%20detection.jpg)

---

## 📂 Repository Structure

This project is divided into three main folders, each containing a self-contained implementation of one of the approaches.

### [1. Custom Firewall Approach](./Firewall/)
This approach uses `iptables` rules to create a stateful firewall that identifies and blocks common DDoS patterns like SYN floods.

* **Tech Stack:** Netfilter/iptables, Linux Networking
* **Go to this folder for setup and execution instructions.**

### [2. Machine Learning Approach](./Machine%20Learning/)
This approach uses a machine learning model to classify network traffic as either benign or malicious.

* **Tech Stack:** Python, Scikit-learn, Pandas, Imbalanced-learn, Matplotlib
* **Go to this folder for setup and execution instructions.**

### [3. FPGA Hardware Acceleration Approach](./Kria%20KV260%20FPGA/)
This approach offloads the detection logic to a Xilinx Kria KV260 FPGA for high-throughput, low-latency packet analysis.

* **Tech Stack:** PYNQ, Xilinx Vivado, Verilog/HLS
* **Go to this folder for setup and execution instructions.**

---

## 👥 Team Members
* Shlok Yadav
* Prachi Sankhe
* Ayeshna Singh