%script to analyze properties of deformation blobs
I = DefMat;
I(I==1) = 0;
%normalize to 0 to 1
I = mat2gray(I);
%because NaNs get converted to 1
I(I==1) = 0;
level = .15;
BW = im2bw(I, level);

%use region props to get blob info
stats = regionprops(BW,'Centroid',...
    'MajorAxisLength','MinorAxisLength','Area','Orientation');

xcent = vertcat(stats.Centroid);
xcent = xcent(:,1);

