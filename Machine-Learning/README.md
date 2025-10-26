# DDoS Attack Detection using Machine Learning

[![Python 3.9+](https://img.shields.io/badge/Python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![Scikit-learn](https://img.shields.io/badge/Scikit--learn-1.4+-orange)](https://scikit-learn.org/stable/)
[![Pandas](https://img.shields.io/badge/Pandas-2.2+-green)](https://pandas.pydata.org/)

This repository contains a machine learning project designed to detect SYN Flood DDoS attacks from network traffic data. The project uses a **Random Forest Classifier** and explores advanced techniques to handle the severe class imbalance inherent in cybersecurity datasets.

---

## 📋 Table of Contents
- [Project Overview](#-project-overview)
- [Dataset](#-dataset)
- [Methodology](#-methodology)
- [Results](#-results)
- [How to Run](#-how-to-run)
- [Key Libraries](#-key-libraries)

## 🎯 Project Overview

The primary goal of this project is to build a reliable and practical machine learning model capable of distinguishing between legitimate (`BENIGN`) network traffic and malicious SYN Flood (`Syn`) attack traffic.

The key challenge addressed is the **severe class imbalance** found in real-world network data. As the initial data analysis shows, the dataset contains over **4.2 million attack samples** but only around **35,000 benign samples**. A naive model trained on such data would be heavily biased, achieving high accuracy by simply predicting "attack" most of the time, while failing to correctly identify legitimate traffic. This would lead to an unacceptable number of **False Positives** (blocking legitimate users), making the model useless in a real-world scenario.

This project documents an iterative process to overcome this challenge and build a robust, balanced classifier.

## 📊 Dataset

The model was trained on the `Syn.csv` file, which is a subset of a larger network traffic dataset (likely CIC-DDoS2019). The data was pre-filtered to contain only `BENIGN` and `Syn` labeled traffic.

- **Initial Size:** 4,320,541 rows × 88 columns
- **Class Distribution:**
  - **Syn:** 4,284,751 samples (~99.2%)
  - **BENIGN:** 35,790 samples (~0.8%)

After initial cleaning and feature selection, a final set of **20 network-level features** were used for training, including `Flow Duration`, `Protocol`, `Flow Packets/s`, and various TCP flag counts (`SYN Flag Count`, `ACK Flag Count`, etc.).

## ⚙️ Methodology

The project follows a three-stage methodology to arrive at the final, optimized model.

### 1. Baseline Model (The Naive Approach)
The first step was to train a standard `RandomForestClassifier` on the raw, imbalanced dataset. While this approach often yields a high accuracy score, it's misleading because the model learns to favor the overwhelmingly dominant "Syn" class. This results in a poor **recall** for the "BENIGN" class, meaning many legitimate connections would be incorrectly blocked.

### 2. Addressing Class Imbalance with Random Undersampling
To solve the bias problem, we implemented **Random Undersampling**.

- **Analogy: The Overwhelmed Security Guard** 👮
  Imagine a security guard trying to find a single wanted person in a stadium of 100,000 people. They'll quickly get overwhelmed and start making mistakes. Random Undersampling is like giving the guard a much smaller, balanced training exercise: showing them 50 photos of the wanted person mixed with 50 photos of regular people. By training on this balanced set, the guard learns the subtle differences much more effectively.

This technique balances the *training data* by randomly removing samples from the majority class (`Syn`) until it matches the number of samples in the minority class (`BENIGN`). The model is then retrained on this perfectly balanced dataset.

### 3. Optimizing the Decision Threshold
By default, a classifier predicts "attack" if its confidence is > 50%. However, this isn't always the optimal threshold. The final step was to "polish" the model by finding the best possible decision threshold.

This was achieved by:
1.  Using `predict_proba()` to get the model's confidence score for each prediction.
2.  Calculating the **Precision-Recall Curve** for all possible thresholds.
3.  Identifying the threshold that maximized the **F1-Score**, which represents the best balance between precision and recall.
4.  Using this new, optimized threshold for the final predictions.

## 📈 Results

The final, optimized model demonstrates a significant improvement in its ability to correctly identify benign traffic without sacrificing its ability to detect attacks. The key result is a dramatic reduction in **False Positives** (benign traffic blocked) compared to the naive baseline model.

The classification report and confusion matrix from the final model show a highly balanced performance, with strong precision and recall for both the `BENIGN` and `Syn` classes. This indicates that the model is both secure (it catches attacks) and reliable (it doesn't block legitimate users), making it suitable for practical deployment.

## 🚀 How to Run

1.  **Clone the repository.**
    ```bash
    git clone [https://github.com/shloooooook/Distributed-Denial-of-Service-DDoS-Detection-and-Prevention.git](https://github.com/shloooooook/Distributed-Denial-of-Service-DDoS--Detection-and-Prevention.git)
    cd Distributed-Denial-of-Service-DDoS-Detection-and-Prevention.git
    ```
2.  **Set up a Python virtual environment and activate it.**
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    ```
3.  **Install dependencies.**
    ```bash
    pip install -r requirements.txt
    ```
4.  **Download the Dataset:** You will need the `Syn.csv` file. Place it inside the `Machine Learning/dataset/` directory.
5.  **Run the Jupyter Notebook:** Open and run the `ddos_predictions.ipynb` notebook in a Jupyter environment.

## 📦 Key Libraries
- **`Pandas`**: For data manipulation and loading.
- **`Scikit-learn`**: For the `RandomForestClassifier`, data scaling, and evaluation metrics.
- **`Imbalanced-learn`**: For the `RandomUnderSampler` technique.
- **`Matplotlib` & `Seaborn`**: For plotting the confusion matrix and other visualizations.