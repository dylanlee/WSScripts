%figure 2 panel 1
% plot(200:330,SHWS10cl(1,5721:5851),'r','LineWidth',3)
% hold on
% plot(200:330,WS09CR(1,5721:5851)+.25,'LineWidth',3)
% plot(1:111,SHWS10cl(1,5741:5851),'r','LineWidth',3)
% set(gca,'xtick',[])
% set(gca,'xticklabel',[])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])


% 
% %vegetation density against migration rate
% plot(AllMeanResults(:,2),AllMeanResults(:,1),'o','markersize',10,'markerfacecolor','b')
% xlabel('Vegetation Density (as fraction plant cover)')
% ylabel('Vc m/9months')
% fig = gcf;
% set(findall(fig,'-property','FontSize'),'FontSize',20)
% %set(findall(fig,'-property','FontWeight'),'FontWeight','bold')
% 
% %2 panel plot of vegetation density trend and migraton rate trend
% subplot(2,1,1)
% plot(nanmoving_average(AveAllVcs,40),'linewidth',3)
% ylabel('Vc m/9months')
% xlabel('Along Wind Distance (m)')
% xlim([0 12015])
% 
% subplot(2,1,2)
% plot(nanmoving_average(ReSampAvePlantDens,40),'color',[0 .5 0],'linewidth',3)
% ylabel('$\rho_{veg}$','interpreter','latex')
% xlabel('Along Wind Distance (m)')
% xlim([0 12015])
% set(findall(fig,'-property','FontSize'),'FontSize',20)
% %%
%figure 3 subpanel plot (figure 4 in paper)
%panel 1 is plot of migration rate on one yaxis and density on the other
subplot(3,1,1)
xran = 0:10400;
[hAx,hLine1,hLine2] = plotyy(xran,nanmoving_average(AveAllVcs(1600:12000),50),xran,nanmoving_average(AveVegDensNoInt(1600:12000),50));
set(hLine1,'linewidth',3)
set(hLine2,'linewidth',3)
set(findall(fig,'-property','FontSize'),'FontSize',30)
pbaspect(hAx(1),[6 1 1])
pbaspect(hAx(2),[6 1 1])
xlim(hAx(1),[0 10400])
xlim(hAx(2),[0 10400])
axis tight
%xlabel('Along Wind Distance (m)')
ylabel(hAx(1),'$V_c$ (m/yr)','interpreter','latex') % left y-axis
ylabel(hAx(2),'$\rho_{veg}$','interpreter','latex') % right y-axis

%panel 2 WAS smoothed deformation
% subplot(3,1,2)
% plot(xran(400:end),nanmoving_average(AveAllDef(1999:12000),50),'LineWidth',3)
% %xlabel('Along Wind Distance (m)')
% ylabel('$q_{sD}$','interpreter','latex') % right y-axis
% set(findall(fig,'-property','FontSize'),'FontSize',22)
% pbaspect([6 1 1])
% ylim([min(AveAllDef) .24])
% axis tight
% xlim([0 10400])

%NEW panel 2 needs the variables in the workspace you create to plot the D2min map 
%below
subplot(3,1,2)
AveTotalPlanDef = nanmean(vqAff+vqMin);
plot(xq(1,41:301)-1600,AveTotalPlanDef(1,41:301),'LineWidth',3)
ylabel('$D_{aff}+D^{2}_{min}$','interpreter','latex','Color','b')
set(findall(fig,'-property','FontSize'),'FontSize',30)
pbaspect([6 1 1])
axis tight

%panel 3 is coherent dune deformation density
subplot(3,1,3)
semilogy(ux(2:end)-1600,cohdefseries(2:end),'o','MarkerSize',12, 'MarkerFaceColor','b')
xlabel('Along Wind Distance (m)')
ylabel('$\rho_{c}$','interpreter','latex','Color','b')
set(findall(fig,'-property','FontSize'),'FontSize',30)
pbaspect([6 1 1])
axis tight
xlim([0 10400])

% %D2min maps plotting. Below code interpolates the data Behrooz gave you and
% %plots the maps as a panelled plot (comment) out this section when not using it
% %x_pos and y_pos variables are in d2min_map.mat and everything else is in
% %200_WS_BF_4e_1_Dec2015.mat

% subplot(2,1,1)
% [xq,yq] = meshgrid(1:40:12015,1:40:1241);
% vqAff = griddata(x_pos,y_pos,d2aff,xq,yq);
% [c,h] = contourf(xq,yq,vqAff,300,'LineStyle','none');
% ylabel('Across Wind Distance');
% xlim([1990 11920])
% ylim([10 950])
% colorbar
% 
% subplot(2,1,2)
% [xq,yq] = meshgrid(1:40:12015,1:40:1241);
% vqMin = griddata(x_pos,y_pos,d2min,xq,yq);
% [c,h] = contourf(xq,yq,vqMin,300,'LineStyle','none');
% caxis([1e-28 4.0e-25])
% ylabel('Across Wind Distance');
% xlabel('Along Wind Distance (m)');
% xlim([1990 11920])
% ylim([10 950]) 
% colorbar
% set(findall(gcf,'-property','FontSize'),'FontSize',22)


