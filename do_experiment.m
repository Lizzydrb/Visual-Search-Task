function [reactionTime, correct, key] = do_experiment(n, cond, target)
% do_experiment function measures the reaction time of finding a target
% present or absent in the Treisman experiment.
% (By Lisa Thelen and Lizzy Da Rocha Bazilio)

%% Create figure
Treisman_exp(n, cond, target)

%% Measure reaction time
tic 
pause

reactionTime = toc;

key = get(gcf, 'CurrentCharacter');

%% Check whether response is correct or not
if target == 0 && strcmpi(key, 'n') == 1
    correct = 1;
elseif target == 1 && strcmpi(key, 'y') == 1
    correct = 1;
elseif strcmpi(key, 'y')==0 && strcmpi(key, 'n')==0
        correct = 0;
else correct = 0;
end
     
end

