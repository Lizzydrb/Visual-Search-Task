function  onex = pickone(x)
% pickone(x) returns a random element from vector x
% Input is a vector, x; output is one random value from vector

if iscell(x)
    onex = x{randi(length(x))};
else
    onex = x(randi(length(x)));
end

end
