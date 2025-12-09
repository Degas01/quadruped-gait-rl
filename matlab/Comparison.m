clear; close all; clc;

R_DDPG = load('Results1.mat');
R_TD3 = load('Results2_TD3.mat');
Train_TD3 = load('TrainingStats_14_04_24_TD3.mat');

Train_DDPG = load('Simulation_14_03_24.mat','trainingStats');

figure(1); clf;
plot(R_DDPG.experience.Reward.Time, R_DDPG.experience.Reward.Data)
hold on
plot(R_TD3.experience.Reward.Time, R_TD3.experience.Reward.Data)
legend('DDPG', 'TD3')
xlabel('Simulation Time')
ylabel('Reward')

figure(2); clf;
plot(Train_DDPG.trainingStats.EpisodeIndex, Train_DDPG.trainingStats.AverageReward)
hold on
plot(Train_TD3.trainingStas.EpisodeIndex,Train_TD3.trainingStats.averageReward)
axis([0 1000 -400 300])
legend('DDPG', 'TD3')
xlabel('Time steps')
ylabel('Average Reward')