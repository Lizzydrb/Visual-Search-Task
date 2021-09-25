function  put_symbol_inFigure(s, k)
% put_symbol_inFigure function places a letter (symbol) s, with colour k
% at location rand in a figure.
% (By Lisa Thelen and Lizzy Da Rocha Bazilio)

% rand = array of 1 x 2, with numbers between 0 and 1 (relative in figure),
% first is x-coordinate, second is y-coordinate
% INPUT:
% s = string, e.g. 'X' or 'O'
% k = string that gives the colour, e.g. 'g' or 'r'

	g=text(rand, rand, s);
	set(g, 'color', k);
    set(g, 'FontSize', 20);
    xlim([-.1 1.1]);
    ylim([-.1 1.1]);
end