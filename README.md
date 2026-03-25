Here’s a clean, GitHub-ready `README.md` you can use for your project:

---

# BUSKLP

**BUSKLP** is a lightweight toolchain for generating long-play (LP) waveforms and preparing them for **laser-cut vinyl record production**.

This project enables you to:

* Convert `.wav` audio into a **linear waveform representation**
* Generate **LP-ready groove data (18–23 minutes)**
* Export a `.txt` file for use in laser-cutting workflows
* Render a **printable PDF vinyl matrix** using Processing

Originally inspired by work from **Amanda Ghassaei**, this version has been simplified and adapted for smoother usage.

---

## 🎧 Overview

BUSKLP consists of two main parts:

### 1. Python Generator

* Converts `.wav` audio into a `.txt` waveform
* Optimizes audio for LP duration (18–23 minutes)

### 2. Processing Renderer

* Reads the `.txt` waveform file
* Generates a **laser-cuttable vinyl spiral layout**
* Outputs a printable PDF

---

## ⚙️ Requirements

* Python 3.x
* Processing ([https://processing.org/](https://processing.org/))
* A `.wav` audio file (mono recommended)

---

## 🚀 Usage

### Step 1 — Generate waveform data (Python)

Edit the file:

```python
# BuskLP-Generate.py
fileName = "track.wav"  # file to be imported (change this)
```

Run the script:

```bash
python BuskLP-Generate.py
```

This will generate a `.txt` file containing the **linear waveform geometry** of your audio.

---

### Step 2 — Prepare for laser cutting (Processing)

Open:

```
LaserCutRecord.pde
```

Set your generated file:

```java
static String filename = "track._output_lp.txt"; 
// generate a txt file of your waveform using python wav to txt,
// and copy the file name here
```

Run the sketch in Processing.

This will generate a **PDF file** ready for:

* Laser cutting
* Vinyl matrix printing

---

## 📀 Notes on Audio Length

* Designed for **18–23 minutes** of audio (LP format)
* Longer audio may require resampling or compression
* Best results with clean, normalized input audio

---

## ✨ Credits

* Original concept and research: **Amanda Ghassaei**
* Adaptation and simplification: **#asytrick**

---

## 📫 Contact

For questions, suggestions, or collaborations:

**Email:** [eusmool@gmail.com](mailto:eusmool@gmail.com)

---

## 🛠️ Status

This is a **small experimental contribution** aimed at making DIY vinyl cutting more accessible and practical.

---

## ⚠️ Disclaimer

This tool is intended for experimental and artistic use. Results may vary depending on:

* Laser cutter precision
* Material used
* Audio complexity

---

If you want, I can also add badges, images, or a diagram of the workflow to make the README more visually appealing.
