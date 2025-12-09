# Gait Control for Quadruped Robot using Reinforcement Learning
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Python](https://img.shields.io/badge/python-3.10+-blue)](https://www.python.org/)
[![Build](https://img.shields.io/github/actions/workflow/status/<your-org>/<repo>/ci-tests.yml?branch=main)](https://github.com/<your-org>/<repo>/actions)
[![GitHub stars](https://img.shields.io/github/stars/<your-org>/<repo>?style=social)]()

## TL;DR
A research-grade implementation and analysis of gait control for a Unitree A1–style quadruped using TD3, DDPG and a modified DDPG (mDDPG). Includes Simulink training environment, RL agents, training logs and demo videos. (Full final report in `/docs`.)

---

## Demo
![td3-demo-small.gif](assets/gifs/td3-demo-small.gif)  
(Click the image to view full video) — or view full demos in `assets/videos/` and the Releases section.

---

## Key results
- TD3 achieved faster convergence and higher average reward than DDPG in the MATLAB Simulink environment (see `results/learning_curves/TD3_vs_DDPG.png`). :contentReference[oaicite:3]{index=3}
- Trained policies exported: `models/td3_policy.pt` (PyTorch) + MATLAB saved workspace.

---

## How this repo is organized
(brief tree) — see above.

---

## Quick start (local)
```bash
# clone
git clone https://github.com/<you>/<repo>.git
cd <repo>

# create conda env (or use Docker)
conda env create -f environment.yml
conda activate quadruped-rl

# run a short smoke test (simulate 5s)
python -m src.scripts.run_demo --agent td3 --duration 5
