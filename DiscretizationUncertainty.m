%Script to randomly select N dunes from one of your DEM's then
%try and asses how the Discretization effects your Vc and resulting prod values.
%Randomly select profiles
numProf = 1;
UncertProfiles = randi([1,1241],1,numProf);
% get rid of repeats in profiles
UniqUncertProfiles = unique(UncertProfiles);
while (length(UniqUncertProfiles) ~= length(UncertProfiles))
    UncertProfiles = randi([1,1241],1,numProf);
    UniqUncertProfiles = unique(UncertProfiles);
end
%Run dune finder on your randomly selected profiles
alldeldisp = cell(1,numProf);
allduneprod = cell(1,numProf);
for k = 1:numProf
    k
    rowind = UncertProfiles(k);
    crsec = WS09CR(rowind,:);
    % make sure to use .3 for your threshold argument since you are trying to
    % replicate results of findVc.m
    [mintabst,mintable,maxtab] = dunefinder(crsec,.3);
    mintabst = mintabst'; mintable = mintable'; maxtab = maxtab';
    dunedeldisp = zeros(length(mintabst),100);
    duneprod = cell(length(mintabst),100);
    %Go dune by dune and shift by resolution 100 x greater than 1m
    for i = 1:length(mintabst(:))
        i
        dst = mintabst(i,1);
        dend = mintable(i,1);
        %adding 2m to dend and dst so have something to shift into! Need the 2m at beginning so you don't mess up your no motion correlation
        dend2 = dend + 2;
        dst2 = dst - 2;
        dune = crsec(dst2:dend2);
        shiftvec = dst2:.01:dend2;
        finedune = spline(dst2:dend2,dune,shiftvec);
        dune = zeros(length(dst),100);
        for l = 1:100 %only need to shift by one meter to look at discretization errorplot
            
            shiftdune = [zeros(1,l-1) finedune];
            %find Vc by shifting along shift mat 1m at a time
            if (dend2) < length(crsec)
               for t = 1:2
                    dst3 = 201 + (t-1) * 100;
                    dend3 = (length(shiftdune) - (199+l)) + (t-1) * 100;
                    %dune2 is the subset of "dune" that is the actual dune without the interdune padding.
                    dune2 = finedune(201:end-200);
                    %dune3 is the part of shiftdune that dune 2 is currently comparing to
                    dune3 = shiftdune(dst3:dend3);
                    corvals(t) = min(min(corrcoef(dune2,dune3)));
                end
                [Mval,Vc] = max(corvals);
                %All values need to be shifted since Vc is essentially an index (ie
                %if Vc = 1 it is actually zero. Also makes sense to shift because your
                % 1st corval is calculated with the dunes not moving at all.
                Vc = Vc -1;
                %Get the prod value error that comes about by shifting dune by Vc instead of actual shift
                % You know the ideal prod value would be zero
                dst4 = 201 + Vc *100;
                dend4 = (length(shiftdune) - (199+l)) + Vc * 100;
                dune4 = shiftdune(dst4:dend4);
                proddef = dune4-dune2;
            end
            %now store the gap between your found Vc and the actual shift
            shift = l * .01;
            deldisp = shift - Vc;
            dunedeldisp(i,l) = deldisp;
            duneprod{i,l} = proddef;
        end
        %remove empty reads (for dunes that didn't get shifted cause to close to edge)
        dunedeldisp( ~any(dunedeldisp,2), : ) = []; %rows
    end
    %Accumulate your error results for all profiles
    alldeldisp{k} = dunedeldisp;
    allduneprod{k} = duneprod;
end
%Plot up your error
%the sawtooth error function is pretty characteristic so just plot 1st row of dunedeldisp 
% here. Then plot the average
% aveproderror = zeros(1,100);
maxproderror = zeros(1,100);
proderrholder = zeros(1,67);
% minproderror = zeros(1,100);
for z = 1:100
%     movmeanArg2 = mat2cell(ones(67,1) * 2000,ones(1,67),1);
%     movmeanArg3 = cell(67,1);
%     movmeanArg3(:) = {'Endpoints'};
%     movmeanArg4 = cell(67,1);
%     movmeanArg4(:) = {'discard'};
%     maxproderror(z) = mean(cellfun(@max,cellfun(@movmean,duneprod(:,z),movmeanArg2,movmeanArg3,movmeanArg4,'UniformOutput',false)));
%     minproderror(z) = mean(cellfun(@min,duneprod(:,z)));
    for w = 1:67
        partprod = duneprod{w,z}(1:floor(.8*end));
        partprodsm = movingAverage(abs(partprod),2000);
        proderrholder(w) = max(partprodsm);
    end
    maxproderror(z) = mean(proderrholder);
end

plot(maxproderror,'LineWidth',3)
xlabel('Actual dune position relative to discrete dune position (m)')
ylabel('Ave. $\left | \prod \right |$ error (m/9 months)','Interpreter','latex')
set(findall(gcf,'-property','FontSize'),'FontSize',22)


%Now sample uniformly from the error range of -.5,.5m to get an idea for what the error is on you across-wind
%averaged values
allr = zeros(1,1000);
for i = 1:30000
    i
    r = -.5 + (.5+.5)*rand(1000,1);
    allr(i) = mean(r);
end

histogram(allr,100,'Normalization','probability')
ylabel('Normalized frequency')
xlabel('Distribution of ave. discretization errors')
set(findall(gcf,'-property','FontSize'),'FontSize',22)


