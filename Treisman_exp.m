function Treisman_exp(n, cond, target)
% Treisman_exp function creates a figure with n objects,
% with or without a target for a disjunctive or conjunctive visual search.
% (By Lisa Thelen and Lizzy Da Rocha Bazilio)

% INPUT:
% n = number of objects (target + distractors)
% cond = 'c' of 'dcol' of 'dsym'
% target = 0 or 1 (target is absent or present)

%% Input checks
% Set size (n) needs to be 8, 24, 40 or 56.
if n ~= 8 && n ~= 24 && n ~= 40 && n ~= 56
    error('Incorrect set size n')
end

% Condition needs to be 'c', 'dcol' or 'dsym'
if strcmpi(cond, 'dcol')==0 && strcmpi(cond, 'dsym')==0 && strcmpi(cond, 'c')==0
    error('Incorrect condition')
end

% Target must be absent (0) or present(1)
if ~(target == 0 || target == 1)
    error('Incorrect target')
end

%% Choose colour and symbol of target (random)
ts = pickone({'X', 'O'}); % ts = target symbol
tc = pickone({'r', 'b'}); % tc = target colour

%% Make colour and symbol of distractors (if target is present)
if strcmp(ts,'X')
    ds = 'O';
else ds = 'X';
end
    
if strcmp(tc,'r')
   dc = 'b';
else dc = 'r';
end

%% Create figures (using put_symbol_inFugure function) and add symbols
% Add the distractors at random locations
if cond == 'dcol'
    for i = 1:(n/2)
        put_symbol_inFigure(ds,dc)
    end
    for i = 1:(n/2-target)
        put_symbol_inFigure(ts,dc)
    end
    
elseif cond == 'dsym'
    for i = 1:(n/2)
        put_symbol_inFigure(ds,dc)
    end
    for i = 1:(n/2-target)
        put_symbol_inFigure(ds,tc)
    end
    
elseif cond == 'c'
    for i = 1:(n/2)
        put_symbol_inFigure(ds,tc)
    end
    for i = 1:(n/2-target)
        put_symbol_inFigure(ts,dc)
    end
end

% Add the target (if target is present)
if target == 1
    put_symbol_inFigure(ts, tc)
end
end
