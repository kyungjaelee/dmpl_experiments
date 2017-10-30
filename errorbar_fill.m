function h = errorbar_fill(x, means, stds, color)
 
x = reshape(x, 1, []);
means = reshape(means, 1, []);
stds = reshape(stds, 1, []);
X = [x, fliplr(x)];
Y = [means-stds, fliplr(means+stds)];
 
h = fill(X, Y, color, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
end