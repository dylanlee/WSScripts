%find the average alongwind net migration of the dune as well as the
%lateral variance in the average. AND the deformation rate. Plotting on
%bottom

%load the 09 data. Go profile by profile and find the lengths associated with individual dune profiles

%need to convert Vcs to an array of NaN's to be able to accurately account
%for real zero Vcs and AllDef values

AllVcs = zeros(size(WS09CR));
AllDef = zeros(size(WS09CR));
AllArea = zeros(size(WS09CR));
YR1DPS = zeros(size(WS09CR));
YR2DPS = zeros(size(WS09CR));

AllVcs(AllVcs == 0) = NaN;
AllDef(AllDef == 0) = NaN;
AllArea(AllArea == 0) = NaN;
YR1DPS(YR1DPS == 0) = NaN;
YR2DPS(YR2DPS == 0) = NaN;

%produce shifted 2010 data to create a deformation rate map
SHWS10 = nan(size(WS09CR));


for k = 1:length(WS09CR(:,1))
    k
    crsec = WS09CR(k,:);
    FWcrsec = WS10CR(k,:);
    [mintabst,mintable,maxtab] = dunefinder(crsec,.3);
    mintabst = mintabst'; mintable = mintable'; maxtab = maxtab';
    length(mintabst)
    length(mintable)
    lsdst = [];
    lsdend = [];
    for i = 1:length(mintabst(:))
        
        dst = mintabst(i,1);
        dend = mintable(i,1);
        dune = crsec(dst:dend);
        dwid = dend - dst + 1;
        hdwid = round(dwid/2);
        corvals = zeros(1,round(dwid/2));
        
        %now do a serries of correlations by translating the dune approx half its width
        if (dend + hdwid) < length(crsec)
            for t = 1:hdwid
                dst2 = dst + t -1;
                dend2 = dend + t -1;
                dune2 = FWcrsec(dst2:dend2);
                
                corvals(t) = min(min(corrcoef(dune,dune2)));
            end
           
        %exception for peaks near the endpoint
        
        else
            
            for t = 1:length(crsec) - dend
                dst2 = dst + t -1;
                dend2 = dend + t -1;
                dune2 = FWcrsec(dst2:dend2);
                
                corvals(t) = min(min(corrcoef(dune,dune2)));
            end
            
        end
        
        [Mval,Vc] = max(corvals);
         
        %All values need to be shifted since Vc is essentially an index (ie
        %if Vc = 1 it is actually zero. Also makes sense to shift because your
        % 1st corval is calculated with the dunes not moving at all.
        
        Vc = Vc -1;
         
         %assign the observed Vc to the midpoint of the dune/feature
        Vcloc = dst + hdwid;
        
        AllVcs(k,Vcloc) = Vc;
        
        %calculate the deformation using the shift that produces the peak
        %correlation
        dst3 = dst + Vc;
        dend3 = dend + Vc;
        dune3 = FWcrsec(dst3:dend3);
        def = dune3 - dune;
        
        %size normalized integrated deformation over the profile. %in the
        %McElroy paper a timestep normalization is also performed and this
        %will have to be done if you incorporate the other two years
        AllDef(k,Vcloc) = (1/(2*dwid))*sum(abs(def));
        
        %store area obtained through integration minus the local minimum
        %elevation
        AllArea(k,Vcloc) = trapz(dune3-crsec(dst));
        
        %Store Dune Pos
        YR1DPS(k,dst) = 1;
        YR1DPS(k,dend) = 2;
        YR2DPS(k,dst3) = 1;
        YR2DPS(k,dend3) = 2;

        %create a variably shifted 2010 dataset WITHOUT interdune
        SHWS10(k,dst:dend) = dune3;
        
%         %create a variably shifted 2010 dataset WITH interdune
%         
%         if ~isempty(lsdst)
%             stuff = FWcrsec(lsdend3+1:dst3-1);
%             oldstuff = crsec(lsdend+1:dst-1);
%             %compare lengths and shrink down or stretch out stuff as the need
%             %arises
%             if isempty(stuff) && isempty(oldstuff)
%                 
%                 SHWS10(k,lsdend:dend) = [stuff dune3];
%                 
%             elseif isempty(stuff) && ~isempty(oldstuff)
%                 %both the above statement and the one below assume that if
%                 %stuff or oldstuff is empty the other will only have one
%                 %member. True?
%                 SHWS10(k,lsdend+1:dend) = [oldstuff dune3];
%                 
%             elseif isempty(oldstuff) && ~isempty(stuff)
%                 SHWS10(k,lsdend:dend) = dune3;
%                 
%             elseif length(stuff) ~= length(oldstuff)
%                 
%                 if length(oldstuff) >= 2 && length(stuff) == 1
% 
%                     stuff = stuff*ones(1,length(oldstuff));
%                     SHWS10(k,lsdend+1:dend) = [stuff dune3];
%                     
%                 else
%                         x = 1:length(stuff);
%                         xq = linspace(1,length(stuff),length(oldstuff));
%                         stuff = interp1(x,stuff,xq);
%                         SHWS10(k,lsdend+1:dend) = [stuff dune3];
%                     
%                 end
%             else
%                 
%                 SHWS10(k,lsdend+1:dend) = [stuff dune3];
% 
%             end
%             
%             
%         end
%         
%         
%         
%         
% 
%         
%         %store dune information for next goround
%         lsdst = dst;
%         lsdst3 = dst3;
%         lsdend = dend;
%         lsdend3 = dend3;
%         oldVc = Vc;
%     end
    end 
end

%plotting and further processing
AveAllVcs = nanmean(AllVcs,1);
plot(AveAllVcs,'o')
fig = gcf;
set(findall(fig,'-property','FontSize'),'FontSize',18)
title('Averaged Migration Rate AlongWind')
ylabel('meters')
xlabel('x (m)')
ylabel('Vc (m/9months)')

figure()
AveAllDef = nanmean(AllDef,1);
plot(AveAllDef)

%         else %overlap case
%             %figure out where your dunes overlap and flip a coin to shift
%             %downwind dune down or upwind dune up
%             ovlap = numel(find(~isnan(SHWS10(k,dst:dend)))); %assume overlap comes at end
%             
%             if round(rand(1))
%                 %shift upwind dune
%                 SHWS10(k,lsdst-ovlap:lsdend-ovlap) = SHWS10(k,lsdst:lsdend);
%                 SHWS10(k,dst:dend) = dune3;
%                 
%             else
%                 %shift downwind dune
%                 SHWS10(k,dst3+ovlap:dend3+ovlap) = dune3;
%                 
%             end
%             
%         end
