%n = 'TD3'; 

    %case 'TD3'
        %disp('TD3')
        % ---- Specify agent proterties / rlDDPG ---- %
        %agentOptions = rlTD3AgentOptions();
        %agentOptions.SampleTime = Ts;
        %agentOptions.DiscountFactor = 0.99;
        %agentOptions.MiniBatchSize = 128;
        %agentOptions.ExperienceBufferLength = 1e6;
        %agentOptions.TargetSmoothFactor = 1e-3;
        % agentOptions.NoiseOptions.MeanAttractionConstant = 0.15;
        % agentOptions.NoiseOptions.Variance = 0.1;
        
        %agentOptions.ActorOptimizerOptions.Algorithm = "adam";
        %agentOptions.ActorOptimizerOptions.LearnRate = 1e-4;
        %agentOptions.ActorOptimizerOptions.GradientThreshold = 1;
        %agentOptions.ActorOptimizerOptions.L2RegularizationFactor = 1e-5;
        
        %agentOptions.CriticOptimizerOptions(1).Algorithm = "adam";
        %agentOptions.CriticOptimizerOptions(1).LearnRate = 1e-3;
        %agentOptions.CriticOptimizerOptions(1).GradientThreshold = 1;
        %agentOptions.CriticOptimizerOptions(1).L2RegularizationFactor;
        
        %agentOptions.CriticOptimizerOptions(2).Algorithm = "adam";
        %agentOptions.CriticOptimizerOptions(2).LearnRate = 1e-3;
        %agentOptions.CriticOptimizerOptions(2).GradientThreshold = 1;
        %agentOptions.CriticOptimizerOptions(2).L2RegularizationFactor;
        %agent = rlTD3Agent(actor,critic,agentOptions);