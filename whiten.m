%another prewhitening function. a good value for the fudge factor is 1e-6
%the largest eigenvalue of A

function [X] = whiten(X,fudgefactor)
X = bsxfun(@minus, X, mean(X));
A = X'*X;
[V,D] = eig(A);
X = X*V*diag(1./(diag(D)+fudgefactor).^(1/2))*V';
end