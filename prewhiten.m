function [X, W] = prewhiten(X)
%PREWHITEN Performs prewhitening of a dataset X
%
%   [X, W] = prewhiten(X)
%
% Performs prewhitening of the dataset X. Prewhitening concentrates the main
% variance in the data in a relatively small number of dimensions, and 
% removes all first-order structure from the data. In other words, after
% the prewhitening, the covariance matrix of the data is the identity
% matrix. The function returns the applied linear mapping in W.
%
%
%
% INSIDDE Terahertz Image Processing Toolbox v0.1
% ===============================================
%
% Copyright (c) 2014 Laurens van der Maaten, Hamdi Dibeklioglu, and Wouter Kouw.
%     Delft University of Technology, The Netherlands.
% All rights reserved.
% 
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
% 3. All advertising materials mentioning features or use of this software
%    must display the following acknowledgement:
%    This product includes software developed by the Delft University of Technology.
% 4. Neither the name of the Delft University of Technology nor the names of 
%    its contributors may be used to endorse or promote products derived from 
%    this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY LAURENS VAN DER MAATEN, HAMDI DIBEKLIOGLU, AND WOUTER 
% KOUW ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
% TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL LAURENS VAN DER MAATEN, HAMDI DIBEKLIOGLU, AND 
% WOUTER KOUW BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
% OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED 
% AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
% EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
%
% 
% The research leading to these results has received funding from the European Union 
% Seventh Framework Programme (FP7/2007-2013) under grant agreement no. 600849.


    % Compute and apply the ZCA mapping
    X = X - repmat(mean(X, 1), [size(X, 1) 1]);
    W = inv(sqrtm(cov(X)));
    X = X * W;    