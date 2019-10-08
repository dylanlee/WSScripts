function [rowdiv,coldiv] =findgriddivs(A,g)

%takes matrix A and uses the divider g to determine a squarish division of
%grids
[r,c] = size(A);

%compute grid division locations for rows and columns
[q, rem] = quorem(sym(r), sym(g));
rowdiv = ones(1,double(q));
rowdiv = rowdiv*g;
%if remainder is nonzero tack add remainder to last value of rowdiv
if rem ~=0
    rowdiv(end) = g + rem;
end
rowdiv = double(rowdiv);

[q, rem] = quorem(sym(c), sym(g));
coldiv = ones(1,double(q));
coldiv = coldiv*g;

%if remainder is nonzero tack add remainder to last value of coldiv
if rem ~=0
    coldiv(end) = g+rem;
end
coldiv = double(coldiv);