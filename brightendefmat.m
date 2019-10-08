%get rid of all values above a certain limit in defmat.

%It is important to choose someting sensible. Really just trying to get rid
%of the what should only be ~.1% of outliers in the data
function brightdefmap = brightendefmat(DefMat,Cutoff)

[sortvals, sortind]=sort(DefMat(:),'descend');
blankit = find(sortvals > Cutoff);
brightdefmap = DefMat;
brightdefmap(sortind(1:max(blankit))) = NaN;