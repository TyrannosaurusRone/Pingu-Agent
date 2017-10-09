%% Pingu searches for Robbie the seal
% Alexander Tarroni and Urvi Parekh

clear all
clc
% Initialise the 5x5 matrix representing igloos

S = reshape(1:100,10,10)';

% Initialise the empty 25x25 matrix for the transition function to fill
ST = zeros(100,100);

% Loop twice over the matrix to compare the adjacency of the states
% If the state satisfies the condition of being directly above, below,
% right or left (i.e. no diagonal moves), indicate a move is possible with a 1.
[rows, cols] = size(S);
for x1 = 1:rows
    for y1 = 1:cols
        for x2 = 1:rows
            for y2 = 1:cols
                if (((abs(x1-x2) == 1) && (abs(y1-y2) == 0)) || ((abs(x1-x2) == 0) && (abs(y1-y2) == 1))) == 1
                ST(S(x1,y1), S(x2,y2)) = 1;
                end
            end
        end
    end
end
%% Reward Matrix 
% rows = agent is now in the sate 
% columns = agent to go in the state 
R = csvread('R100.csv',1,1);

% Initialise the Q matrix as a zero matrix
Q = zeros(size(R));  
%% Implementing a random policy


alpha = 0.7;
gamma = 0.7;
episode = 0;
epsilon = 0.9;% set the epsilon value to 0.9
path_list = [];
cum_rew_list = [];
cum_exp_rewList = [];
time_elapsed = [];

for episode = 1:5000
    currentState = 1; % always start at state 1, the top left square on the grid
    step = 1;
    path = [];
    cum_reward = 0;
    cum_exp_reward = 0;
tic
while ((step < 1000)  && (currentState < 100))

    rd = rand; % Generate a uniform random number (rd) for everystep where 0<rd<1 
                % The function rand will generate a random number in interval(0,1)


    % find where there is a one in the state-action matrix ST, indicating a
    % possible move to that state i.e. an action.
    avState = find(ST(currentState, :) == 1);
    [rows, cols] = size(avState); % rows = number of possible actions
    
    Qreward = zeros(4,2); % initialise empty matrix for 'short-term' memory of future rewards

    for i = 1:cols % loops for number of possible actions
         % take the reward value from the Q matrix by indexing with current
         % state and i of possible action
        avStateReward = Q(currentState,avState(i));
        Qreward(i, :) = [avState(i),avStateReward]; % save the available states and their rewards in a 4x2 matrix Qreward.
    end

    if rd >= epsilon % Greedy policy finds maximum reward from the possible moves
        
        maxIndex = find(Qreward(:,2) == max(Qreward(:,2))); 
        actionV = Qreward(maxIndex,1);
        action = [];
        if sum(actionV ~= 0) > 1
            action = randsample(actionV(actionV~=0),1); 
            disp('Chose a random state out of equivalent maximum rewards');
        else
            action = actionV(actionV ~= 0);
        end
        if epsilon >= 0.5
            epsilon = epsilon*0.99999;
        else
            epsilon = epsilon*0.9999;
        end
        disp('Chose Greedy Policy')
    else % The random policy chooses a move at random
        action = randsample(avState,1);
        if epsilon >= 0.5
            epsilon = epsilon*0.99999;
        else
            epsilon = epsilon*0.9999;
        end
        disp('Chose Random Policy')
    end
    
    
    % find where there is a one in the state-action matrix ST, indicating a
    % possible move to that state i.e. an action.
    avState2 = find(ST(action, :) == 1);
    [rows2, cols2] = size(avState2); % gives number of possible actions
    
    Qreward2 = zeros(4,2); % initialise empty matrix for 'short-term' memory of future rewards

    for i = 1:cols2 % loops for number of possible actioons
         % take the reward value from the Q matrix by indexing with current
         % state and i of possible action
        avStateReward2 = Q(action,avState2(i));
        Qreward2(i, :) = [avState2(i),avStateReward2]; % save the available states and their rewards in a 4x2 matrix Qreward.
    end

    % Implementing update rule
    Q(currentState, action) = Q(currentState, action) + alpha*(R(currentState, action) + gamma*(max(Qreward2(:,2)) - Q(currentState, action)));
    cum_reward = cum_reward + R(currentState, action);
    cum_exp_reward = cum_exp_reward + max(Qreward(:,2));
    path = cat(2, path, currentState);
    currentState = action;
    step = step + 1;
end
toc
[pathrw, pathcl] = size(path);
path_list = cat(1, path_list, pathcl);
%cum_rew_list = cat(1, cum_rew_list, cum_reward / (step -1)); % average rewad per step 
cum_rew_list = cat(1, cum_rew_list, cum_reward); %cumulative reward 
episode = episode +1;
time_elapsed = cat(1, time_elapsed,toc);
end

%% Normalise Q-matrix
[qrow, qcol] = size(Q);
QSA = qrow*qcol;
maxQ = max(max(Q));
if maxQ > 0 
    Q = 100*Q/maxQ;
end

%% Plots

figure;
plot(time_elapsed);
ylabel('Time Elapsed (s)');
xlabel('Episodes');
title('Time Elapsed vs. Episodes')

%% %% Plot 2 - combination of path list and cumulative reward

figure;
yyaxis right;
plot(cum_rew_list);
ylabel('Cumulative Reward per episode');
hold on
yyaxis left;
xlabel('Episodes');
plot(path_list);
ylabel('Steps');
