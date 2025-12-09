%n = 'DDPG';  

    %case 'DDPG'
        %disp('DDPG')
        % ---- Specify agent properties / rlDDPG ---- %
        %agentOptions = rlDDPGAgentOptions();
        %agentOptions.SampleTime = Ts;
        %agentOptions.DiscountFactor = 0.99;
        %agentOptions.MiniBatchSize = 128;
        %agentOptions.ExperienceBufferLength = 1e6;
        %agentOptions.NoiseOptions.MeanAttractionConstant = 0.15;
        %agentOptions.NoiseOptions.Variance = 0.1;
        
        %agentOptions.ActorOptimizerOptions.Algorithm = "adam";
        %agentOptions.ActorOptimizerOptions.LearnRate = 1e-4;
        %agentOptions.ActorOptimizerOptions.GradientThreshold = 1;
        %agentOptions.ActorOptimizerOptions.L2RegularizationFactor = 1e-5;
        
        %agentOptions.CriticOptimizerOptions.Algorithm = "adam";
        %agentOptions.CriticOptimizerOptions.LearnRate = 1e-3;
        %agentOptions.CriticOptimizerOptions.GradientThreshold = 1;
        %agentOptions.CriticOptimizerOptions.L2RegularizationFactor;
        %agent = rlDDPGAgent(actor,critic,agentOptions);
 