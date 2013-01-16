function [X] = vec2img(X)
% get image from vector
% (output in range [0,1])

wxh = [92 112];

% set min to 0
X = X - min(X);

% normalize
s = max(X);
if s > eps
    X = X ./ s;
end

% vector to matrix
X = reshape(X, wxh(2), wxh(1));


end


