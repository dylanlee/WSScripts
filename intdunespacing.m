%trying to use the peak to peak spacing of dunes to get a density estimate
AllSpaces = zeros(size(WS09CR));
AllSpaces(AllSpaces == 0) = NaN;

%smoothing window for dune peak detection
win = 20;
shift = win/2; %if win is odd shift becomes floor(win/2) +1

%use the maxtab output of peakdet to get the peak locations

for k = 1:length(WS09CR(:,1))
    k
    crsec = WS09CR(k,:);
    crsecSM = movingAverage(crsec,win);
    [maxtab, mintab] = peakdet(crsecSM,.1);
    Spaces = zeros(1,length(WS09CR(1,:)));
    
    for i = 1:length(maxtab(:,1))
        %indexes of elevations
        ptpst = maxtab(i,1) + shift;
        
        %unfiltered max value heights
        firph = maxtab(i,2);
        
        
        %find the closest identified minimum to this max value height
        [c idx] = min(abs((mintab(:,1)+shift) - ptpst));
        minph = mintab(idx,2);
        
        %height of pile of sand
        pileh = firph - minph;
        
        %minimum height something should have attained to be conse
        heightthresh = .5;
        %if the upwind peak is 3 meters taller than the downwind peak then
        %consider that peak shielded and don't include it in your distance
        %measure.
%          if  pileh >= heightthresh
             
            %this seems a little weird but it will get normal when you
            %subtract the distances to find the peak to peak spacings
            Spaces(ptpst) = ptpst;
            
%          else
% 
%             %do nothing. Remember want to get rid of the divots in the
%             %interdune zone. These divots are what will have the biggest
%             %height differential.
%             
%         end
        
    end
    
    %now get the peak to peak spacings
    
    Spaces2 = find(Spaces);
    Spaces3 = diff(Spaces(Spaces2));
    Spaces(Spaces2(2:end)) = Spaces3;
    Spaces(Spaces2(1)) = 0;
    Spaces(Spaces == 0) = NaN;
    
    %now apply moving average to get an idea of the average peak to peak
    %centered around that location
    
    %want to use a pretty large value here for the smoothing window(slightly larger than the
    %largest peak to peak spacing)
    win2 = 360;
    shift2 = win2/2;
    
    Spaces = nanmoving_average(Spaces,win2);
    AllSpaces(k,:) = Spaces;
    
    %some viz for sanity checking
%     plot(crsec)
%     hold on
%     plot(maxtab(:,1)+shift,maxtab(:,2),'ro')
%     plot(mintab(:,1)+shift,mintab(:,2),'ro')
    
end