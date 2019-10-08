% Select 10 profiles at random from the 2009 elevation map. Then for each
% of the 10 profiles select 10 200m ranges at random from the profile. Make
% sure to have the 'ProfileUncert.mat' workspace loaded as
% you'll be using the variables from this

UncertProfiles = randi([1,1241],1,10);
% get rid of repeats in profiles
UniqUncertProfiles = unique(UncertProfiles);

while (length(UniqUncertProfiles) ~= length(UncertProfiles))
    UniqUncertProfiles = unique(UncertProfiles);
end

AllCutPro = zeros(20,12015);
AllDunLoc = cell(1,20);

for i = 1:10
    %Call dunefinder.m on the profiles in question
    crsec = WS09CR(UncertProfiles(i),:);
    
    % now generate the ranges looked at in each individual profile where you randomly generate the
    % start of the range and then add 200 to get the end range in the 2nd
    % column.
    ProfileRanges = randi([1,12015],1,10);
    
    % Look for overlap in the profile ranges. If overlap exists then generate a
    % new set of profile ranges until there is no overlap
    ovlapcheck = abs(diff(ProfileRanges));
    numovlap = find(ovlapcheck<=200);
    
    %clause to take care of ranges that run over the end of the dune
    %profile.
    if ~isempty(find((ProfileRanges + 200) > 12015))
        ProfileRanges = randi([1,12015],1,10);
        ovlapcheck = abs(diff(ProfileRanges));
        numovlap = find(ovlapcheck<=200);
    end
    
    while (numovlap > 0)
        if ~isempty(find((ovlapcheck + 200) > 12015))
            ProfileRanges = randi([1,12015],1,10);
            ovlapcheck = abs(diff(ProfileRanges));
            numovlap = find(ovlapcheck<=200);
        end
        ProfileRanges = randi([1,12015],1,10);
        ovlapcheck = abs(diff(ProfileRanges));
        numovlap = find(ovlapcheck<=200);
    end
    
    %need to use the same selectivity value you actually used in 'findVc.m'
    sel = .3;
    [allstossloc,allleeloc,maxtab] = dunefinder(crsec,sel);
    
    %cut the profile you generated so that only selected ranges will be
    %graphed. IE replace non used elevations with NaN
    cutpr = nan(1,12015);
    for k = 1:10
        ranst = ProfileRanges(k);
        ranen = ranst + 199;
        ran = crsec(ranst:ranen);
        cutpr(ranst:ranen) = ran;
    end
    
    %store cut profiles
    AllCutPro(i,:) = cutpr;
    
    % Store all the start and stop locations for all profiles in a cell
    % array
    AllDunLoc{i} = [allstossloc, allleeloc, maxtab]; 
    
end

%use the profile ranges you generated to plot sections that you can use to
%evaluate the algorithms performance by eye.