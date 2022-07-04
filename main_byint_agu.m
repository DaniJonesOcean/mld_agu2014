%
% main_byint_agu : version for AGU (more self-contained)
%

%% Clean up workspace -------------------------------------

clear all
clear memory
close all

%% Add paths ----------------------------------------------

addpath ~/matlabfiles/
addpath ~/matlabfiles/m_map

%% Read grid info -----------------------------------------

load('/data/expose/sose_08-10/raw_data/grid.mat',...
     'XC','YC','RC','DRC','hFacC')

% repmat
DZ = repmat(DRC,[1 size(XC,1) size(XC,2)]);
DZ = permute(DZ,[2 3 1]);

%% More setup stuff ---------------------------------------

% Critical density difference (kg/m^3)
delta_rho_crit = 0.03;

% Load list of iterations
load('its_stt.txt')
its = its_stt;

% Starting date as a 'date number' (days from year 0)
date_num0 = datenum('2018-01-01 00:00:00');

% Input file locations
floc = '/data/expose/tracer_runs_expose/prod_agu/run/';

%% Loop through files, calc mixed layer depth -------------

for niter=1:length(its)

    % Display progress
    disp('---------------------------------------')
    disp(100*niter/length(its))

    % Set date
    date_num(niter) = date_num0 + 182.62.*(niter-1);

    % Read fields
    disp('Reading DRHODR')
    DRHODR = rdmds(strcat(floc,'STTdiags'),its(niter),'rec',5);

    disp('Calculating delta_rho')   

    % Initialize
    delta_rho = zeros(size(DRHODR));

    % Calculate delta_rho everywhere
    for k=2:size(DZ,3)

        delta_rho(:,:,k) = nansum(-1.0.*DRHODR(:,:,1:k).*...
                                         DZ(:,:,1:k),3);

    end

    % Get mixed layer depth
    disp('Calculating mixed layer depth')
    mld(:,:,niter) = getmld(RC,delta_rho,delta_rho_crit);
    disp('mld calcualted')

end

save('mld_agu.mat',mld,date_num,delta_rho_crit)

