clear;
close('all');

% Init Epanet
start_toolkit;

% Load data
load('TestWorkspace.mat');

% Variables to set

% Coagulation
i = length(Ti);
dosisArray = [];

% Sedimentation
s = epanet('Net00-new.inp');
hours = length(Ti); % h
qi1 = 150; % LPS
qi2 = 150; % LPS
h1 = 1;
h2 = 1;

% Initial q change

% Sediment 1
% qin
% valveID = '2'; 
% valveIndex = s.getLinkIndex(valveID);
% s.setLinkInitialSetting(valveIndex, qi1);
% qout
% valveID = '12';
% valveIndex = s.getLinkIndex(valveID);
% s.setLinkInitialSetting(valveIndex, qi2);

% Sediment 2
% qin
% valveID = '13';
% valveIndex = s.getLinkIndex(valveID);
% s.setLinkInitialSetting(valveIndex, s_qi);
% qout
% valveID = '14';
% valveIndex = s.getLinkIndex(valveID);
% s.setLinkInitialSetting(valveIndex, s_qi);

% Link to graph
link_names = {'12'};
link_indices = s.getLinkIndex(link_names);

% Node to graph (Tank)
node_names = {'3'};
node_indices = s.getNodeIndex(node_names);

% Hydraulic analysis using ENepanet binary file
s.setTimeSimulationDuration(hours*3600);
hyd_res = s.getComputedTimeSeries;

% Change time-stamps from seconds to hours
hrs_time = hyd_res.Time/3600;

% Initialize hydraulic analysis
s.openHydraulicAnalysis;
s.initializeHydraulicAnalysis;

tstep=1; F=[]; t=[]; V=[]; h = 0;

for x = 1:i
    
    % Coagulant dosis
    dosis = coagulantFunc(Ti(x), Ci(x))
    dosisArray(x) = dosis;
    %pause(1)
    
    % Tank level status
        % if (level >= max) then (open sludge discharge valve)
        % if (level <= min) then (close sludge discharge valve)
    for y = (1+h):(60+h)
        
        % Hydraulic Analysis - step by step (step = 1sec)
        t(y) = s.runHydraulicAnalysis;
        tf = s.runHydraulicAnalysis;
        
        % Flows matrix
        F = [F; s.getLinkFlows];
        % Volume matrix
        V = [V; s.getNodeTankVolume];
        % Epanet next tstep
        tstep = s.nextHydraulicAnalysisStep;
        
            figure (1);
            
            % Flow
            subplot(2,1,1);
            plot((t/3600), F(:,link_indices));
            drawnow;
            title(['Flow for the link id "', s.getLinkNameID{link_indices},'"']);
            xlabel('Time (h)'); 
            ylabel(['Flow (', s.LinkFlowUnits,')']);
            
            % Tank Volume
            subplot(2,1,2);
            plot((t/3600), V(:,node_indices));
            drawnow;
            title(['Flow for the node id "', s.getNodeNameID{node_indices},'"']);
            xlabel('Time (h)'); 
            ylabel(['Volume (', s.NodeTankVolumeUnits,')']);
    end
    
    % Next hour
    h = h + 60;
end

