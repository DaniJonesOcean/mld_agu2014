%
% plot_mld_agu
%

%% Clean up workspace
clear all
clear memory
close all

%% Colorbar
load('~/colormaps/div11_RdYlBu.txt')
cmp = div11_RdYlBu./256;

%% Load grid
load('/data/expose/sose_08-10/raw_data/grid.mat')

%% Load mld
load('mld_agu.mat')
date_str = datestr(date_num);
mld = abs(mld);

%% Make plots
for niter=2:2:50

    figure('Color','w','units','pixels',...
           'position',[100 100 1100 500])

    contourf(XC,YC,squeeze(mld(:,:,niter)),0:50:600)
    shading flat
    colorbar
    colormap(flipud(cmp))
    title(strcat('Winter MLD (m) :',date_str(niter,1:11)))

    print('-depsc',strcat('plot/mld_iter',date_str(niter,1:11),'.eps'))

end

%% Average winter between 40-60S?

dA = DXC.*DYC;
dAA = repmat(dA,[1 1 50]);
f = repmat(hFacC(:,:,1),[1 1 50]);

% Mean between 
j1 = 108;
j2 = 228;

num = squeeze(nansum(squeeze(nansum(mld(:,j1:j2,:).*...
                             dAA(:,j1:j2,:).*f(:,j1:j2,:)))));
den = squeeze(nansum(squeeze(nansum(dAA(:,j1:j2,:).*f(:,j1:j2,:)))));

mld_mean = num./den;

figure('color','w','units','pixels','position',[90 110 1100 500])

h1=line(date_num,mld_mean);
set(h1,'linewidth',2.0,'color','k')
datetick('x',11)

ylabel('Mean mixed layer depth (m)')
title('Mean MLD 40-60 S')

set(gca,'xgrid','on','ygrid','on','fontsize',12)

print('-depsc2','plot/mld_40-60_mean.eps')
