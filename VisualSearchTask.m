% VisualSearchTask script runs the Visual Search Task experiment.
% (By Lisa Thelen and Lizzy Da Rocha Bazilio)

% Ensure the seed is always different
rng('shuffle')

%% Set up the interface
% We have chosen to show the figure in full screen, completely white
% in order to eliminate as many distractors as possible.
fig = figure('units','normalized',...
    'outerposition',[0 0 1 1]);

ax = axes(fig,'xcolor',get(gcf,'color'),...
    'position', [0 0 1 1],...
    'xtick',[],...
    'ycolor',get(gcf,'color'),...
    'ytick',[]);

% Ask the subject to fill in their anonymous participant number
ID = str2double(inputdlg('Please enter the participant number you were handed randomly to ensure anonymity: '));
validateattributes(ID,{'numeric'},{'nonempty','positive', 'integer', 'scalar'},mfilename,'Participant Number',1)

%% Practice round
[textbox] = popup('Welcome and thank you for participating in this task!\n\n We will start the experiment with a practice round. Before you can continue to the actual experiment,\nyou will need to have at least 70%% of the practice round correct!\n\n Press any key to continue to the instructions.', fig)
pause
delete(textbox)

[textbox] = popup('Instructions:\n When you see a target, press Y as quickly as possible.\nIf there is no target, press N.\n\n The experiment is not case sensitive. \n\nPress any key to start.\n\nGood luck!', fig);
pause
delete(textbox)

% Initiaze variables
PracTrial = 0;
CorrectCount = 0;
setsize = [8, 24, 40, 56];

% Run at least 10 trials
% Stop when subject has at least 70% of all trials correct
while CorrectCount./PracTrial < 0.7 || CorrectCount == 0 || PracTrial < 10
    PracTrial = PracTrial + 1;
    
    % Pick whether target is present or absent
    % Create random probability between 0 and 1
    p_target = rand;
    
    % For 80% of trials, target is present, 20% target is absent
    if p_target <= 0.8
        target = 1;
    else target = 0;
    end
    
    % Pick the set size (n) and condition (cond) randomly
    n = pickone(setsize);
    cond = pickone({'dcol', 'dsym', 'c'});
    
    % Use the do_experiment function to create the figures and measure the reaction time
    [reactionTime, correct, key] = do_experiment(n, cond, target);
    
    % Count the correct trials
    if correct == 1
        CorrectCount = CorrectCount + 1;
    end
    
    % Clear current trial symbols
    delete(findall(gcf,'String', 'O'))
    delete(findall(gcf,'String', 'X'))
    
    % Display a pop-up message when subject does not press the instructed keys
    if strcmpi(key, 'y')==0 && strcmpi(key, 'n')==0
        [textbox] = popup('Please make sure you press Y or N.\n\n Press any key to continue.', fig);
        pause
        delete(textbox)
    end
end

%% Actual experiment
% Instruction screen
[textbox] = popup('You have successfully completed the practice round, well done!\n\n You will now start the actual experiment.\n Press any button to see the instructions again.', fig)
pause
delete(textbox)

[textbox] = popup('Instructions:\n When you see a target, press Y as quickly as possible.\nIf there is no target, press N.\n\n The experiment is not case sensitive. \n\nPress any key to start.\n\nGood luck!', fig);
pause
delete(textbox)

%% Initialize variables
TrialNumber = 0;
BlockEnd = 0; % To initiate blocks
CorrectCount = 0;
hit = 0;
MinHit = 20; % Minimum of 20 hits per combination, count backwards
setsize = [8, 24, 40, 56];
check = 1;

%% Generate all possible combinations of set size (n) and condition (cond)
for i_combi = 1:4
    combi(i_combi,:) = {setsize(i_combi), 'dcol', MinHit};
    combi(i_combi+4,:) = {setsize(i_combi), 'dsym', MinHit};
    combi(i_combi+8,:) = {setsize(i_combi), 'c', MinHit};
end

%% While loop for every trial
% Maximum of 600 trials
% Stop loop when subject has 20 hits (target is present and pressed 'y')
% for all possible combinations (lines 96-100) (check == 0)
while TrialNumber < 600 && check == 1
    
    % Increase trial number and block end number for every trial
    TrialNumber = TrialNumber + 1;
    BlockEnd = BlockEnd + 1;
    
    % Give the subject a break after 100 trials
    if BlockEnd == 101 && TrialNumber < 599
        BlockEnd = 0;
        [textbox] = popup('Take a break before you continue.\n\nThe task stays the same.\n\nPress any key to start again.', fig);
        tic
        pause
        BreakTime = toc
        delete(textbox)
    else BreakTime = 0;
    end
    
    % Pick whether target is present or absent
    % Create random probability between 0 and 1
    p_target = rand;
    
    % For 80% of trials, target is present, 20% target is absent
    if p_target <= 0.8
        target = 1;
    else target = 0;
    end
    
    % Pick the set size (n) and condition (cond)
    n = pickone(setsize);
    cond = pickone({'dcol', 'dsym', 'c'});
    
    % Use the do_experiment function to create the figures and measure the reaction time
    [reactionTime, correct, key] = do_experiment(n, cond, target);
    
    % Check per trial whether trial was a hit
    if target == 1 && correct == 1
        hit = 1;
    else hit = 0;
    end
    
    % Store the data in a vector of struct
    data(TrialNumber).Condition = cond;
    data(TrialNumber).SetSize = n;
    data(TrialNumber).Answer = key;
    data(TrialNumber).Correctness = correct;
    data(TrialNumber).Time = reactionTime;
    data(TrialNumber).Target = target;
    data(TrialNumber).SubjectID = ID;
    data(TrialNumber).TrialNumber = TrialNumber;
    data(TrialNumber).TimeofBreak = BreakTime;
    data(TrialNumber).Hits = hit;
    
    % Clear current trial symbols
    delete(findall(gcf,'String', 'O'))
    delete(findall(gcf,'String', 'X'))
    
    % Display a pop-up message when subject does not press the instructed keys
    if strcmpi(key, 'y')==0 && strcmpi(key, 'n')==0
        [textbox] = popup('Please make sure you press Y or N.\n\n Press any key to continue.', fig);
        pause
        delete(textbox)
    end
    
    % Count correct number of trials up until present moment
    if correct == 1
        CorrectCount = CorrectCount + 1;
    end
    
    % For every block of 100 trials:
    % display a warning if in the last 50 trials 
    % subject has answered less than 75% correct
    if BlockEnd == 50 && ((CorrectCount/TrialNumber) < 0.75 || CorrectCount == 0)
        [textbox] = popup('Warning!\n\n You have answered some questions wrong.\n\nCheck if your fingers are on the right buttons\nRight buttons: Y and N', fig);
        pause
        delete(textbox)
    end
    
    % For every combination, if there is a hit, remove it from MinHit
    if strcmp(cond, 'dcol') == 1 && target == 1 && correct == 1
        combi{setsize == n, 3} = combi{setsize == n, 3} - 1;
    elseif strcmp(cond, 'dsym') == 1 && target == 1 && correct == 1
        combi{(find(setsize == n)+4), 3} = combi{(find(setsize == n)+4), 3} - 1;
    elseif strcmp(cond, 'c') == 1 && target == 1 && correct == 1
        combi{(find(setsize == n)+8), 3} = combi{(find(setsize == n)+8), 3} - 1;
    end
    
    % Make sure MinHit is not negative before placing it in a matrix
    if combi{setsize == n, 3} < 0
        combi{setsize == n, 3} = 0;
    elseif combi{(find(setsize == n)+4), 3} <0
        combi{(find(setsize == n)+4), 3} = 0;
    elseif combi{(find(setsize == n)+8), 3} < 0
        combi{(find(setsize == n)+8), 3} = 0;
    end
    
    % Check if all combinations fulfill the minimal hit rate of 20
    % If all fulfilled, change check to 0
    check = combi(:,3)';
    check = any(cell2mat(check));
    
end

%% End experiment
% Display a final message
popup('The task is completed, thank you for participating!\n\nGoodbye!\n\n\nPress any key to close the screen.', fig);
pause

close all

%% Save the data 
filename = int2str(ID);
save(filename, 'data')