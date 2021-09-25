% DataAnalysis script plots a figure displaying the results of a
% VisualSearchTask experiment.
% (By Lisa Thelen and Lizzy Da Rocha Bazilio)

%% Load the data files and prepare the figure
% Prompt user to load the data file containing results of 
% the visual search task for one subject
uiopen('load')

% Prepare figure
ResultPlot = figure('units','normalized',...
    'outerposition',[0 0 1 1]);

% Set axes
title('Visual Search Task Results', 'fontsize', 30);
xlabel('Set Size', 'fontsize', 20)
ylabel('Reaction Time (s)', 'fontsize', 20)
set(gca, 'XTick', [0 8 24 40 56 64], 'FontName', 'Monospaced');
xlim([0 64]);
ylim([0 6]);
hold on

%% Data retrieval from vector of structs "data"
% Retrieve data of 'dcol' condition 
Data_dcol = data(:,find(strcmp({data.Condition}, 'dcol') == 1));
Data_dcol = Data_dcol(intersect(find([Data_dcol.Correctness]),find([Data_dcol.Target])));
plot([Data_dcol.SetSize], [Data_dcol.Time],'bx')

% Retrieve data of 'dsym' condition 
Data_dsym = data(:,find(strcmp({data.Condition}, 'dsym') == 1));
Data_dsym = Data_dsym(intersect(find([Data_dsym.Correctness]),find([Data_dsym.Target]))); 
plot([Data_dsym.SetSize], [Data_dsym.Time],'ro')

% Retrieve data of 'c' condition
Data_c = data(:,find(strcmp({data.Condition}, 'c') == 1));
Data_c = Data_c(intersect(find([Data_c.Correctness]),find([Data_c.Target])));
plot([Data_c.SetSize], [Data_c.Time],'kd')

%% Plot the data points of the reaction times of the hit trials
% Plotting all individual data points of the hit trials
% per condition
for i_setsize = 1:4
    plotdata(i_setsize).dcol = [Data_dcol(find([Data_dcol.SetSize] == setsize(i_setsize))).Time];
    plotdata(i_setsize).dsym = [Data_dsym(find([Data_dsym.SetSize] == setsize(i_setsize))).Time];
    plotdata(i_setsize).c = [Data_c(find([Data_c.SetSize] == setsize(i_setsize))).Time];
end

%% Calculate the mean values for each condition (cond)
% Initialize mean variables for each condition
Mean_dcol = [];
Mean_dsym = [];
Mean_c = [];

% Creating the mean value of each condition per set size using the 
% plots of hits per set size 
for i_setsize2 = 1:4
    Mean_dcol = [Mean_dcol,mean(plotdata(i_setsize2).dcol)];
    Mean_dsym = [Mean_dsym,mean(plotdata(i_setsize2).dsym)];
    Mean_c = [Mean_c,mean(plotdata(i_setsize2).c)];
end

%% Plot the mean lines
% Drawing a line trough the mean values per condition per set size
line(setsize,Mean_dcol,'color','b')

line(setsize,Mean_dsym,'color','r')

line(setsize,Mean_c,'color','k')

%% Add a legend for each condition
% Creating a legend that shows what the different colours ans symbols 
% stand for in terms of the different conditions
legend('pop-out colour', 'pop-out symbol', 'conjunction search', 'Location','NorthWest')