classdef CustomDDPGAgent < rl.agent.CustomAgent
        %CUSTOMREINFORCEAGENT Custom REINFORCE agent
        
        %% Properties (set properties attributes accordingly)
        properties
            % Actor representation
            Actor
            TargetActor
    
            % Critic
            Critic
            TargetCritic
    
            % Agent options
            Options
            DiscountFactor
            TargetSmoothFactor
            ExperienceBufferLength
            MiniBatchSize
            
            % Experience buffer
            ObservationBuffer
            ActionBuffer
            RewardBuffer
            nextObservationBuffer
        end
        
        properties (Access = private)
            % Training utilities
            Counter
            noise
            Variance
            NumObservation
            NumAction
        end
        
        
        %% Necessary Functions
        %======================================================================
        % Implementation of public function
        %======================================================================
        methods
            function obj = CustomDDPGAgent(Actor, Critic, Options)
                %CUSTOMREINFORCEAGENT Construct custom agent
                %   AGENT = CUSTOMREINFORCEAGENT(ACTOR,OPTIONS) creates custom
                %   REINFORCE AGENT from rlStochasticActorRepresentation ACTOR
                %   and structure OPTIONS. OPTIONS has fields:
                %       - DiscountFactor
                %       - MaxStepsPerEpisode
                
                % (required) Call the abstract class constructor.
                obj = obj@rl.agent.CustomAgent();
             
                obj.ActionInfo = Actor.ActionInfo;
                
                % (required for Simulink environment) Register sample time. 
                % For MATLAB environment, use -1.
                % (optional) Register actor and agent options.
                Actor = setLoss(Actor,@actorlossFunction);
                Critic = setLoss(Critic,@criticlossFunction);
                obj.Actor = Actor;
                obj.Critic = Critic;
                obj.TargetActor = Actor; % make it same copy with Actor
                obj.TargetCritic = Critic;% make it same copy with Critic
    
                obj.SampleTime = Options.SampleTime;
                obj.Variance = Options.NoiseOptions.Variance;
                obj.Options = Options;
                            
                % (optional) Cache the number of observations and actions.
                obj.NumObservation = prod(obj.ObservationInfo.Dimension);
                obj.NumAction = prod(obj.ActionInfo.Dimension);
                
                % (optional) Initialize buffer and counter.
                reset(obj);
            end
        end
        
        %======================================================================
        % Implementation of abstract function
        %======================================================================
        methods (Access = protected)
            function Action = getActionImpl(obj,Observation)
                % Compute an action using the policy given the current 
                % observation.
                Action = getAction(obj,Observation);
            end
            
            function Action = getActionWithExplorationImpl(obj,Observation) % not important in my ddpg
                % Compute an action using the exploration policy given the  
                % current observation.
                
                % REINFORCE: Stochastic actors always explore by default
                % (sample from a probability distribution)
                Action = getAction(obj.Actor,Observation);
            end
           
            function Action = learnImpl(obj,Experience)
                % Define how the agent learns from an Experience, which is a
                % cell array with the following format.
                %   Experience = {observation,action,reward,nextObservation,isDone}
                
                % Reset buffer at the beginning
                if obj.Counter == 0 
                    resetBuffer(obj);
                end
                
                % Extract data from experience.
                Obs = Experience{1};
                Action = Experience{2};
                Reward = Experience{3};
                NextObs = Experience{4};
                IsDone = Experience{5};
                
                % Save data to buffer.
                obj.Counter = mod(obj.Counter, obj.Options.ExperienceBufferLength) + 1;
                obj.ObservationBuffer(:,:,obj.Counter) = Obs{1};
                obj.ActionBuffer(:,:,obj.Counter) = Action{1};
                obj.RewardBuffer(:,obj.Counter) = Reward;
                obj.nextObservationBuffer(:,:,obj.Counter) = NextObs{1};
                obj.IsDoneBuffer(:,obj.Counter) = IsDone;
                
                if ~IsDone
                    % Choose an action for the next state.
                    
                    Action = getAction(obj.Actor, NextObs);
                    Action = {(Action{1})+OUNoise(obj)};
                else
                    % Learn from replay memory.
                    % Collect data from the buffer.
                    BatchSize = min(obj.Counter,obj.Options.MiniBatchSize);
                    batchindexs=sort(randperm(obj.Counter,BatchSize));
                    ObservationBatch = obj.ObservationBuffer(:,:,batchindexs); 
                    ActionBatch = obj.ActionBuffer(:,:,batchindexs);
                    RewardBatch = obj.RewardBuffer(:,batchindexs);
                    nextObservationBatch = obj.nextObservationBuffer(:,:,batchindexs);
                    IsDoneBatch = obj.IsDoneBuffer(:,batchindexs);
                    
                    %calculate critic loss  
                    Ybatch = zeros(1,BatchSize);
                    Qbatch = zeros(1,BatchSize);
                    for t = 1:BatchSize
                        nextAction = getAction(obj.TargetActor, {nextObservationBatch(:,:,t)});
                        Ybatch(t) = RewardBatch(t) + (1-IsDoneBatch).*obj.Options.DiscountFactor*getValue(obj.TargetCritic,{nextObservationBatch(:,:,t)}, nextAction);
                        Qbatch(t) = getValue(obj.Critic,{ObservationBatch(:,:,t)}, {ActionBatch(:,:,t)});
                    end
                    % Organize data to pass to the loss function.
                    criticLossData.closs = mean((Ybatch - Qbatch).^2);
                    % Compute the gradient of the loss of the critic with respect to the
                    % the outputs of the actor.
                    
                    Inputdata{1} = ObservationBatch;
                    Inputdata{2} = ActionBatch;
                    CriticGradient = gradient(obj.Critic,'loss-parameters',...
                        Inputdata,criticLossData);
                    % Update the critic parameters using the computed gradients.
                    obj.Critic = optimize(obj.Critic,CriticGradient);
                    
                    
                    %calculate actor loss
                    Inputdata = getAction(obj.Actor, {ObservationBatch});
                    min(Inputdata{1})
                    max(Inputdata{1})
                    Critic2InputGradient = gradient(obj.Critic,'output-input',...
                        [ObservationBatch,Inputdata]);
                    aloss = -mean(Critic2InputGradient{2});
                    % Organize data to pass to the loss function.
                    LossData.aloss = aloss;
                    % Compute the gradient of the loss of the actor with respect to the
                    % actor parameters.
                    input={ObservationBatch};
                    ActorGradient = gradient(obj.Actor,'loss-parameters',...
                        input,LossData);
                    %https://uk.mathworks.com/help/reinforcement-learning/ug/train-reinforcement-learning-policy-using-custom-training.html
                    % Update the actor parameters using the computed gradients.
                    obj.Actor = optimize(obj.Actor,ActorGradient);
                    obj.TargetCritic = syncParameters(obj.TargetCritic,obj.Critic,obj.Options.TargetSmoothFactor);
                    obj.TargetActor = syncParameters(obj.TargetActor,obj.Actor,obj.Options.TargetSmoothFactor);
                end
            end
        end
        
        %% Optional Functions
        %======================================================================
        % Implementation of optional function
        %======================================================================
        methods (Access = protected)
            function resetImpl(obj)
                % (Optional) Define how the agent is reset before training.
                
                resetBuffer(obj);
                obj.Counter = 0;
                obj.noise = 0;
            end
        end
        
        methods (Access = private)
            function resetBuffer(obj)
                % initialize all experience buffers.
                
                obj.ObservationBuffer = zeros(obj.NumObservation,1,obj.Options.ExperienceBufferLength);
                obj.ActionBuffer = zeros(obj.NumAction,1,obj.Options.ExperienceBufferLength);
                obj.RewardBuffer = zeros(1,obj.Options.ExperienceBufferLength);
                obj.nextObservationBuffer = zeros(obj.NumObservation,1,obj.Options.ExperienceBufferLength);
            end
        end
    end
    
    function actorloss = actorlossFunction(repr,lossData)
        x=sum(repr, 'all')+1;
        x=x/x;% To bypass the traced dlarray requiremet 
        actorloss = x*lossData.aloss;
    end
    function criticloss = criticlossFunction(repr,criticLossData)
        x=sum(repr, 'all')+1;
        x=x/x;% To bypass the traced dlarray requiremet 
        criticloss = x*criticLossData.closs;
    end
    
    function noise = OUNoise(obj)
    obj.noise = obj.noise + 0.15.*(0 - obj.noise).*obj.SampleTime + obj.Variance.*randn(size(0)).*sqrt(obj.SampleTime);
           decayedVariance = obj.Variance.*(1 - obj.Options.NoiseOptions.VarianceDecayRate);
    obj.Variance = max(decayedVariance,0);
    noise=obj.noise;
    end