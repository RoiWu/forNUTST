function A = psf2A(psf, bc)

assert(size(psf, 1) == size(psf, 2))
m = size(psf, 1);
A = zeros(m*m);
X = eye(m*m);
for i=1:m*m
    x = X(:, i);
    x = reshape(x, [m, m]);
    x_conv_psf = imfilter(x, psf, 'conv', 'same', bc);
    A(:, i) = x_conv_psf(:);
end
