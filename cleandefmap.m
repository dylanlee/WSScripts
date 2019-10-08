%script to replace the zero values in your shifted lidar map with local
%minimum elevations. Once you have the grid logic you can also use this for
%the gridbased autocorrelation analysis

[r,c] = size(SHWS10);

%choose a grid size that is on the order of the along wind length of a
%couple dunes
grsi = 50;


[rowdiv,coldiv] =findgriddivs(SHWS10,grsi);
% %lindensitymins = zeros(rowdiv,coldiv);
% %use mat2cell to divide up matrix
gridcell = mat2cell(DefMat,rowdiv,coldiv);

%data range for cross correlation
x = 1:grsi;
%return nonzero minimum of each grid and replace zero values with that
%minimum
for i = 1:length(rowdiv)
    for k = 1:length(coldiv)
        A = gridcell(i,k);
        A = cell2mat(A);
        m = min(A(A>0));
        %lindensitymins(i,k) = m;
        if isempty(m) == 0
            A(A==0) = m;
            gridcell(i,k) = {A};
        else
            A(A==0) = NaN;
            gridcell(i,k) = {A};
        end
    end
end

% lindensity = zeros(1,c);
% %find linear density
% %lindensitymins = mean(lindensitymins,1);
% for i = 1:c
%     
%     lindensitymin = min(SHWS10(:,i));
%     %add a meter to accound for variance in interdune height
%     numondune = find(SHWS10(:,i)>lindensitymin+1);
%     numondune = numel(numondune);
%     linden = numondune/r;
%     lindensity(i) = linden;
%  
% end
% 
% %convert cellgrid back to matrix
% SHWS10cl = cell2mat(gridcell);
% 
% %make deformation map with adjusted SHWS10
% DefMat = abs(SHWS10cl - WS09CR);
%  
%compute auto-correlation for all the grids
Corlines = [];
slopes = [];
for i = 1:length(rowdiv)
    i
    for k = 1:length(coldiv)
        
        A = gridcell(i,k);
        A = cell2mat(A);
        B = xcorr2(A);
        [ul,ml] = size(B);
        if length(B) == 2*grsi-1
            line = B(ceil(ul/2),ceil(ml/2):end);
            Corlines = [Corlines; line];
            slop = polyfit(x,line,1);
            slopes(i,k) = slop(1); 
        end
    end
end
