clear; close all; clc; 

initializeRobotParameters
% load('rlQuadrupedAgent.mat'); 

mdl = "rlQuadrupedRobot";
open_system(mdl)

numObs = 44;
obsInfo = rlNumericSpec([numObs 1]);
obsInfo.Name = "observations";

numAct = 8;
actInfo = rlNumericSpec([numAct 1],LowerLimit = -1,UpperLimit = 1);

actInfo.Name = "torque";

blk = mdl + "/RL Agent";
env = rlSimulinkEnv(mdl,blk,obsInfo,actInfo);

env.ResetFcn = @quadrupedResetFcn;

rng(0)


[criticNetwork1, criticNetwork2, actorNetwork] = createNetworks(numObs,numAct);

actor = rlContinuousDeterministicActor(actorNetwork,obsInfo,actInfo);
critic = rlQValueFunction(criticNetwork1,obsInfo,actInfo);


n = 'DDPG';  % DDPG, TD3

switch n
    case 'DDPG'
        disp('DDPG')
        % ---- Specify agent proterties / rlDDPG ---- % 
        agentOptions = rlDDPGAgentOptions();
        agentOptions.SampleTime = Ts;
        agentOptions.DiscountFactor = 0.99;
        agentOptions.MiniBatchSize = 128;
        agentOptions.ExperienceBufferLength = 1e6;
        agentOptions.TargetSmoothFactor = 1e-3;
        agentOptions.NoiseOptions.MeanAttractionConstant = 0.15;
        agentOptions.NoiseOptions.Variance = 0.1;
        
        agentOptions.ActorOptimizerOptions.Algorithm = "adam";
        agentOptions.ActorOptimizerOptions.LearnRate = 1e-4;
        agentOptions.ActorOptimizerOptions.GradientThreshold = 1;
        agentOptions.ActorOptimizerOptions.L2RegularizationFactor = 1e-5;
        
        agentOptions.CriticOptimizerOptions.Algorithm = "adam";
        agentOptions.CriticOptimizerOptions.LearnRate = 1e-3;
        agentOptions.CriticOptimizerOptions.GradientThreshold = 1;
        agentOptions.CriticOptimizerOptions.L2RegularizationFactor;


        agent = rlDDPGAgent(actor,critic,agentOptions);

    case 'TD3'
        disp('TD3')
        % ---- Specify agent proterties / rlDDPG ---- % 
        agentOptions = rlTD3AgentOptions();
        agentOptions.SampleTime = Ts;
        agentOptions.DiscountFactor = 0.99;
        agentOptions.MiniBatchSize = 128;
        agentOptions.ExperienceBufferLength = 1e6;
        agentOptions.TargetSmoothFactor = 1e-3;
        % agentOptions.NoiseOptions.MeanAttractionConstant = 0.15;
        % agentOptions.NoiseOptions.Variance = 0.1;
        
        agentOptions.ActorOptimizerOptions.Algorithm = "adam";
        agentOptions.ActorOptimizerOptions.LearnRate = 1e-4;
        agentOptions.ActorOptimizerOptions.GradientThreshold = 1;
        agentOptions.ActorOptimizerOptions.L2RegularizationFactor = 1e-5;
        
        agentOptions.CriticOptimizerOptions(1).Algorithm = "adam";
        agentOptions.CriticOptimizerOptions(1).LearnRate = 1e-3;
        agentOptions.CriticOptimizerOptions(1).GradientThreshold = 1;
        agentOptions.CriticOptimizerOptions(1).L2RegularizationFactor;
        
        agentOptions.CriticOptimizerOptions(2).Algorithm = "adam";
        agentOptions.CriticOptimizerOptions(2).LearnRate = 1e-3;
        agentOptions.CriticOptimizerOptions(2).GradientThreshold = 1;
        agentOptions.CriticOptimizerOptions(2).L2RegularizationFactor;

        agent = rlTD3Agent(actor,critic,agentOptions);

end



trainOpts = rlTrainingOptions(...
    MaxEpisodes=10000,...   %default value 10000
    MaxStepsPerEpisode=floor(Tf/Ts),...
    ScoreAveragingWindowLength=250,...
    Plots="training-progress",...
    StopTrainingCriteria="AverageReward",...
    StopTrainingValue=210);

trainOpts.UseParallel = true;                    
trainOpts.ParallelizationOptions.Mode = "async";
% 
doTraining = false;
%doTraining = true;
if doTraining    
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);
else
    % Load pretrained agent parameters for the example.
    load("rlQuadrupedAgentParams.mat","params")
    setLearnableParameters(agent, params);
end

rng(0)

simOptions = rlSimulationOptions(MaxSteps=floor(Tf/Ts));
experience = sim(env,agent,simOptions);


figure(1); clf;
plot(experience.Action.torque.Time,experience.Action.torque.Data(3,:))
xlabel('Time [s]')
ylabel('Torque [Nm]')


% Evaluating (kind of) energy 
Tot = 0; 
for i = 1:8
Tot = Tot + sum(experience.Action.torque.Data(i,:).^2);
disp(Tot)
end 
 
% agent.AgentOptions.SampleTime = 0.025;
% agent.AgentOptions.DiscountFactor = 0.8;   
figure(1); clf;
subplot(2,2,1)
plot(experience.Action.torque.Time, experience.Action.torque.Data(1,:))
hold on
plot(experience.Action.torque.Time, experience.Action.torque.Data(2,:))
title('Leg FL')
ylabel('Torque [Nm]')
legend('hip','knee')
subplot(2,2,2)
plot(experience.Action.torque.Time, experience.Action.torque.Data(3,:))
hold on
plot(experience.Action.torque.Time, experience.Action.torque.Data(4,:))
title('Leg FR')
legend('hip','knee')
subplot(2,2,3)
plot(experience.Action.torque.Time, experience.Action.torque.Data(5,:))
hold on
plot(experience.Action.torque.Time, experience.Action.torque.Data(6,:))
title('Leg RL')
ylabel('Torque [Nm]')
legend('hip','knee')
xlabel('Time [s]')
subplot(2,2,4)
plot(experience.Action.torque.Time, experience.Action.torque.Data(7,:))
hold on
plot(experience.Action.torque.Time, experience.Action.torque.Data(8,:))
title('Leg RR')
xlabel('Time [s]')
legend('hip','knee')
figure(2); clf;
plot(experience.Observation.observations.Time, experience.Observation.observations.Data(6,:)*180/pi)