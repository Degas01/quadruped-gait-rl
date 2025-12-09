# Quadruped Gait Control using Reinforcement Learning (MATLAB & Simulink)

![MATLAB](https://img.shields.io/badge/MATLAB-Simulink-orange)
![Simscape](https://img.shields.io/badge/Simscape-Multibody-blue)
![RL](https://img.shields.io/badge/Reinforcement%20Learning-TD3%20%7C%20DDPG-green)
![Robotics](https://img.shields.io/badge/Robotics-Quadruped-black)
![License](https://img.shields.io/badge/License-Academic-lightgrey)

---

                         <img width="418" height="401" alt="image" src="https://github.com/user-attachments/assets/dfec3201-45a5-4aba-bd6c-486fd0e4e64a" />

## Unitree A1 robot


## 🧠 Project Overview

This repository contains the complete implementation, simulation framework, training experiments and results from my Bachelor of Mechanical Engineering Final Year Project:

> **Gait Control for a Quadruped Robot using Reinforcement Learning**

The objective of this project was to design, simulate, evaluate stable and adaptive quadruped walking gaits using reinforcement learning algorithms. The system was built entirely in **MATLAB**, **Simulink** and **Simscape Multibody**, using the **MATLAB Reinforcement Learning Toolbox**.

Three control strategies were developed and evaluated:
- **DDPG (Deep Deterministic Policy Gradient)**
- **TD3 (Twin Delayed DDPG)**
- **Modified DDPG (mDDPG)**

The project focuses on stability, energy efficiency and convergence performance in simulated locomotion.

---

## Table of Contents

1. Project Objectives
2. System Architecture
3. Simulation Environment
4. Robot Model Description
5. Reinforcement Learning Framework
6. Reward Function Design
7. Neural Network Architecture
8. Training Pipeline
9. Experimental Results
10. Visual Demonstrations
11. Future Work
12. References

---

## 1. Project Objectives

The primary objectives of this project were:

- To design a simulated quadruped robot environment capable of physics-accurate locomotion.
- To implement and compare multiple deep reinforcement learning algorithms for gait generation.
- To analyze the stability, efficiency, and convergence behavior of learned locomotion policies.
- To study control robustness under varying terrain and physical conditions.

---

## 2. System Architecture

This project follows a modular robotics architecture comprising:

- High-frequency physics simulation layer
- Reinforcement learning control policy
- Observation and action encoding layers
- Training and evaluation pipeline
- Full system architecture block diagram
  
<img width="837" height="439" alt="image" src="https://github.com/user-attachments/assets/82fef2cd-ed7d-4d87-a3d3-b0dcce5a0626" />
Adapted from Eriksson et al. (2003, p. 5)

---

## 3. Simulation Environment

The robot and environment were designed using:

- MATLAB
- Simulink
- Simscape Multibody
- Reinforcement Learning Toolbox

The physics simulation provides:
- Joint torque actuation
- Contact dynamics
- Friction modeling
- Center of mass tracking
- Environment state block diagram
  
<img width="898" height="477" alt="image" src="https://github.com/user-attachments/assets/98252937-cb71-4955-a2c1-df554e717279" />

<img width="844" height="463" alt="image" src="https://github.com/user-attachments/assets/f70a23c3-6fed-4418-bba7-490f5d5fa8ca" />

---

## 4. Robot Model Description

The quadruped robot model represents a legged system with:

- Four legs
- Twelve actuated joints
- Active hip and knee joints
- Rigid body dynamics

---

## 5. Reinforcement Learning Framework

Algorithms implemented:

| Algorithm | Description |
|----------|-------------|
| DDPG | Actor–Critic continuous control |
| TD3 | Improved DDPG with twin critics |
| mDDPG | Modified DDPG variant |

The agent receives state observations including:

- Joint angles
- Joint velocities
- Body orientation
- Contact states

Actions are continuous joint torque commands.

<img width="610" height="477" alt="image" src="https://github.com/user-attachments/assets/954b71b5-13c2-48b7-bb04-12875ba45910" />
## RL environment interaction diagram

---

## 6. Reward Function Design

The reward function balances:

- Forward velocity
- Body stability
- Energy consumption
- Joint limit penalties

The final reward formulation includes weighted terms for:

1. R = w1 * velocity_term
2. w2 * torque_penalty
3. w3 * instability_penalty
4. w4 * fall_penalty

---

## 7. Neural Network Architecture

### Actor Network

- Fully Connected Layers
- ReLU activations
- Tanh output scaling
  
<img width="896" height="630" alt="image" src="https://github.com/user-attachments/assets/e3eb0949-91af-431e-bfa9-9cdd47de820f" />
Adapted from Sut et al. (2023)

### Critic Network

- Twin Q-network structure (TD3)
- State and action concatenated input
- TD3 algorithm framework
  
<img width="849" height="535" alt="image" src="https://github.com/user-attachments/assets/46f3be23-ad3b-4213-8ca1-bd69236da50f" />
Adapted from Liu et al. (2022, p. 10)

<img width="778" height="549" alt="image" src="https://github.com/user-attachments/assets/ad1de59c-03cb-4170-a8f5-4d8c8138b147" />
## Structure of DDPG algorithm a = π (s|δ π) and critic network with function Q (s, a|δ Q) respectively
Adapted from Wang et al. (2020)

---

## 8. Training Pipeline

Training workflow:

1. Environment reset
2. State observation
3. Action inference
4. Physics step
5. Reward calculation
6. Gradient update

Training was performed over multiple episodes with replay buffers and policy noise.

---

## 9. Experimental Results

### 9.1 Learning Curves

Comparison of TD3 vs DDPG:

| Metric | TD3 | DDPG |
|--------|-----|------|
| Convergence Speed | Faster | Slower |
| Stability | High | Medium |
| Final Reward | Higher | Lower |

<img width="946" height="509" alt="image" src="https://github.com/user-attachments/assets/0788a232-4fbd-48d1-a9d2-05872d05b03d" />
## TD3 and DDPG comparison between time steps and average reward

---

## 10. Visual Demonstrations

### Gait Demonstrations

| Algorithm | Demo |
|----------|------|
| TD3 | https://github.com/user-attachments/assets/3f8153c4-36c7-4e55-975e-644219c9a8db |
| DDPG | https://github.com/user-attachments/assets/609716b6-9c20-4be3-ba84-026b55bc7cd1 |

## Starting Point 
<img width="652" height="344" alt="image" src="https://github.com/user-attachments/assets/eb232336-00d6-45a7-aa80-ddf21138dfe0" />  

## End Point
<img width="652" height="341" alt="image" src="https://github.com/user-attachments/assets/24d9e0e1-437f-4edd-8fe1-b0d9af20a095" />

---

## 11. Future Work

Planned improvements:

- Real-world hardware implementation
- Terrain adaptation learning
- Domain randomization
- Vision-based locomotion
- Transfer learning to physical robot

---

## 12. References

[1] Lillicrap et al., DDPG
[2] Fujimoto et al., TD3
[3] MATLAB Reinforcement Learning Toolbox Docs
[4] Simscape Multibody Documentation

---
