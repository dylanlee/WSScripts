%Refined dune width finding function mostly using peakfinder (by Nathan Yoder) a couple times but
%with some tricks to adapt it to this case.

%in this function sel will be dependent on the noise threshold height of
%the interdunes

function varargout = dunefinder(crsec,sel)

%find peaks. Using a smoothed version of crsec cause don't care about
%actual positions of peaks just want to get close enough
[smcrsec,trash] = nanmoving_average(crsec,3);
[maxtab,maxmag] = peakfinder(crsec,2,0,1);

%find mins
[mintab,minmag,ind] = peakfinder(crsec,0,1300,-1);

%look right from peak if next min is below min thresh for a dune height then go to the next min
numpeaks = length(maxtab);

%preallocate for speed
cind = 1;
allstossloc = zeros(1,numpeaks+1);
allleeloc = zeros(1,numpeaks+1);
for i = 2:numpeaks-1
    
    %look to peak right and then to peak left and find minimums in between
    laspeakloc = maxtab(i-1);
    curpeakloc = maxtab(i);
    nexpeakloc = maxtab(i+1);
    
    mintabr = mintab(mintab>curpeakloc & mintab<nexpeakloc);    
    
    %if empty then keep searching
    a = 0;
    b = 0;
    
    if isempty(mintabr)
       %ifempty lower standards then break
           mintabr = ind(ind>curpeakloc & ind<nexpeakloc); 
            
    end
    
    mintabl = mintab(mintab<curpeakloc & mintab>laspeakloc);
    
    if isempty(mintabl)
        
        %if empty lower standards then break
        mintabl = ind(ind<curpeakloc & ind>laspeakloc);
        
    end
    
    %now take the minimum of these found values
    rlowrefpoint = min(crsec(mintabr));
    llowrefpoint = min(crsec(mintabl));
    
    %now search around this low refence point in the raw inflection point
    %data you pulled out of peakfinder.
    
    %look to the right of currentpeak 
    rcut = ind(ind>curpeakloc & ind<nexpeakloc);
    leecands = find(crsec(rcut) < rlowrefpoint + sel);
    leeloc = rcut(leecands(1));
    
    %now look to the left of currentpeak
    lcut = ind(ind<curpeakloc & ind>laspeakloc);
    stosscands = find(crsec(lcut) < llowrefpoint + sel);
    stossloc = lcut(stosscands(end));
    
    allstossloc(cind) = stossloc;
    allleeloc(cind) = leeloc;
    cind = cind+1;
end

%clean min output
allstossloc = unique(allstossloc);
allstossloc(allstossloc == 0) = [];
allleeloc = unique(allleeloc);
allleeloc(allleeloc == 0) = [];

% Plot if no output desired
if nargout == 0

        figure;
        plot(crsec);
        hold on
        plot(maxtab(:),crsec(maxtab),'ro')
        plot(allstossloc,crsec(allstossloc),'go')
        plot(allleeloc,crsec(allleeloc),'ko')
else
    varargout = {allstossloc,allleeloc,maxtab};
end

% 1st draft

%     curpeak = maxmag(i);
%     mintabr = mintab(mintab>curpeakloc);
%     [trash, idx] = min(abs(mintabr - curpeakloc));
%     curtroughloc = mintabr(idx);
%     curtrough = crsec(curtroughloc);
%     
%     %looking for the minimum to the right that does satisfy the height
%     %threshold
%     while curtrough > curpeak - sel
%         idx = idx + 1;
%         curtroughloc = mintabr(idx);
%         curtrough = crsec(curtroughloc);
%     end
%     
%     %if min is greater than height threshold record as lee side
%     lee = curtroughloc;
%     
%     %now use this stoss height to look LEFT of peak and find the 1st
%     %value that is aroundish it in magnitude
%     curelev = curpeak;
%     a = 0;
%     while curelev > curtrough
%         a = a + 1;
%         curelev = crsec(curpeakloc - a);
%     end
%     
%     stoss = curpeakloc - a;
%     allmins = [allmins stoss lee];
%     
