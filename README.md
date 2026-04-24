# MOT Task Psychtoolbox (MacOS)

Multiple Object Tracking (MOT) task developed for clinical research. This framework was originally authored in 2009 and has been updated in 2026 to support **modern macOS environments** using **Octave** and **Psychtoolbox-3**.

---

## 🚀 2026 Updates
* **macOS Compatibility:** Optimized for modern display refresh rates and security permissions on Apple Silicon/Intel Macs.
* **Input Mapping:** Refactored keyboard polling and input binds to ensure native compatibility with macOS-specific key inputs (e.g., "Y" and "N" keycode alignment).
* **MATLAB/Octave Integration:** Fully tested on Octave 9.x+ (open-source) as a free alternative to MATLAB.
* **Error Handling:** Improved Psychtoolbox screen initialization and keyboard polling.

---

## 🛠️ Prerequisites
Before running the task, ensure you have the following installed:
1. **Octave** (or MATLAB)
2. **Psychtoolbox-3** (PTB-3)
3. **GStreamer** (Required for PTB-3 media/timing on macOS)

---

## ⚠️ Critical Configuration (Required)
The task is currently configured with local file paths. To save data successfully on your machine, you **must** update the output directory:

1. Open the main script in Octave/MATLAB.
2. Navigate to **Line 644**.
3. Change the path string to a directory on your machine.

---

## 🧪 Task Design
* **Stimuli:** 8 spheres (4 pairs).
* **Target Identification:** 2 targets briefly highlighted green.
* **Movement:** Dynamic circular motion within pairs.
* **Response:** Forced-choice (Y/N) for target matching.
* **Data Output:** Automatic CSV export of Response Time (RT) and Accuracy.

---

## 📂 Repository Structure
- `mot.m` – Main script (modernized from 2009 version for macOS compatibility).
- `mot_demo.m` – Demo script to quickly run and preview the task.
- `.gitignore` – Specifies files and directories excluded from version control.
- `LICENSE` – MIT License for project use and distribution.
- `README.md` – Project overview and usage instructions.

---

## 📄 License & Attribution
Originally developed in 2009. Refactored and modernized by **Dawson Miller** (2026). 
Licensed under the MIT License.
