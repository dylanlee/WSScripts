% % trying to get vegetaiton density out of the high resolution arial data at
% % White Sands
% 
% % load greyscale image
% RefI = imread('/home/dylan/Group/WhiteSands/VegDensity/HighresCrVeg8bit.tif');
% 
% % load thresholded image
% Pmark = imread('/home/dylan/Group/WhiteSands/VegDensity/HighresCrVegHiThr.tif');
% 
% Pmark = im2bw(Pmark);
% 
% 
% [Bedge Redge] = size(Pmark);
% Tedge = 0;
% Ledge = 0;
% 
% %invert image. DO NOT run this line if image has already been inverted
% Pmark = ~Pmark;
% 
% %run regionprops on threshold marker image, Not needed in average
% perimeter color approach
% %Plocs = regionprops(Pmark, 'centroid');
% %Plocs  = cat(1, Plocs.Centroid);
% 
% %plot centroids to check that you are doing it right
% imshow(Pmark)
% hold on
% plot(Plocs(:,1),Plocs(:,2), 'b*')
% hold off

% % dilate pmark
 se = ones(5,5);
 pmarkd = imdilate(Pmark,se);

%Remove the  regions that are on the borders 
pmarkd = imclearborder(pmarkd);

%get areas of regions as well as the pixellist to use to black out large
%areas
Earea = regionprops(pmarkd,'Area','PixelList');
Earea2 = cat(1,Earea.Area);

% %use regionprops to get a collection of pixels on the border of each object
% Elocs = regionprops(pmarkd, 'extrema');
% Elocs = arrayfun(@(v) v.Extrema(1,:), Elocs,'UniformOutput', false);
% Elocs = cell2mat(Elocs);


% %plotting to check results of bwboundaries
% imshow(pmarkd)
% hold on
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
% end

%So slow so for now just going to do this in imagej
% %delete extremely large regions in image
for i = 1:length(Earea2)
    %delete extremely large regions in image
    if Earea2(i) > 3000
        %fill in pixel list with black values
        %apparently this is an extremely slow way to do this...should
        %figure out a way to speed it up
        pmarkd(Earea(i).PixelList(:,2),Earea(i).PixelList(:,1)) = 0;
    end    
end

%find boundaries
B = bwboundaries(pmarkd);
Result2 = zeros(Bedge,Redge);
brightper = 170; %This is something that will need to be tuned but actually 170 doesn't seem that bad
%now step through the boundary information
for k = 1:length(B)
    k
    boundary = B{k};
    %step through all the elements in boundary
    Allpix = 0;
    for l = 1:length(boundary)
        pix = RefI(boundary(l,1),boundary(l,2));
        pix = double(pix);
        Allpix = Allpix + pix;        
    end
    avepix = Allpix/length(boundary);
    if avepix > brightper
        %paste pixels into result image
        %note the use of the original pmark image and not the dilated pmark
        %image
        Result2(boundary(:,1),boundary(:,2)) = Pmark(boundary(:,1),boundary(:,2));
    end
end
% Square ROI approach
% %look for the presence of N pixels above white sand value in the search
% %region.
% %using white sand value of 180 and a square ROI of ~50X50
% %ROI must be odd
% ROI_size = 7;
% 
% 
% for i = 1:length(Plocs)
%     
%     El = floor(ROI_size/2);
%     %is switched from what you would expect because Plocs is read off an image
%     %figure out the location of the region center rounded to the nearest
%     %integer that will allow you to run the rest of the script
%     if ((Plocs(i,2) < Tedge-1) || (Plocs(i,2) > Bedge-1))
%         Rowind = ceil(Plocs(i,2));
%     else
%         Rowind = floor(Plocs(i,2));
%     end
%     
%     if (Plocs(i,1) < Ledge-1) ||  (Plocs(i,1) > Redge-1)
%         Colind = ceil(Plocs(i,1));
%     else
%         Colind = floor(Plocs(i,1));
%     end
%     
%     if ((Rowind - El) <= Tedge) || ((Rowind + El) >= Bedge) || ((Colind -El) <= Ledge) || ((Colind + El) >= Redge)
%         %condition to take care of edge cases
%         ROI = zeros(El*2+1, El*2+1);
%     else
%         ROI = RefI((Rowind - El): (Rowind +El),(Colind-El):(Colind+El));
%         i
%     end
%     SandBrightness = 180; %trying to set sand brightness really high %aiming for about 180 on the 0-255 scale
%     PlantDarkness = 40;
%     % condition that a certain number of pixels need to be classified as
%     % sand
%     Sandthresh = .75 * ROI;
%     numSandPix = length(find(ROI>SandBrightness));
%     numPlantPix = length(find(ROI<PlantDarkness));
%     %if plant region is actually in sand threshold less harshly and then put back into
%     %the larger image
%     if numSandPix > (.50 * numel(ROI)) || numPlantPix > (.50 * numel(ROI))
% 
%         
%         %now stick the puzzle piece in its place
%         %condition to stick piece in place if ROI doesn't spill over edge
%        if ((Rowind - El) <= Tedge) || ((Rowind - El) >= Bedge) || ((Colind -El) <= Ledge) || ((Colind - El) >= Redge)
%             %condition to take care of edge cases
%        else
%         
%             Result((Rowind - El): (Rowind +El),(Colind-El):(Colind+El)) = ROIthresh;
% 
%        end
%     end
% end