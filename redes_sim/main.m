clear;
close('all');

% Init Epanet
start_toolkit;

% Load data (24 h data default)
load('TestWorkspace.mat');

% Variables to set

% Coagulation
i = length(Ti);
dosisArray = [];

% Sedimentation
s = epanet('Net00-new.inp');
hours = 27; % h
s_NTUi = 9;
s_qi1 = 75; % LPS
s_qi2 = 75; % LPS
s_h1 = 1;
s_h2 = 1;

% Hydraulic analysis using ENepanet binary file
s.setTimeSimulationDuration(hours*3600);
hyd_res = s.getComputedTimeSeries;

% Change time-stamps from seconds to hours
hrs_time = hyd_res.Time/3600;

s.openHydraulicAnalysis;
s.initializeHydraulicAnalysis;
tstep=1; F=[]; t=[]; V=[];
h = 0;

link_names = {'12'};
link_indices = s.getLinkIndex(link_names);

node_names = {'3'};
node_indices = s.getNodeIndex(node_names);

for x = 1:i
    
    % Coagulant dosis
    dosis = coagulantFunc(Ti(x), Ci(x))
    dosisArray(x) = dosis;
    %pause(1)
    
    % Tank level status
        % if (level >= max) then (open washing valve)
        % if (level <= min) then (close washing valve)
    for y = (1+h):(60+h)
        
        % Hydraulic Analysis - step by step (step = 1sec)
        t(y) = s.runHydraulicAnalysis;
        tf = s.runHydraulicAnalysis;
        
        % Flows matrix
        F = [F; s.getLinkFlows];
        % Volume matrix
        V = [V; s.getNodeTankVolume];
        % Epanet tstep
        tstep = s.nextHydraulicAnalysisStep;
        
            % Flow to the next unity
            figure (1);
            plot((t/3600), F(:,link_indices));
            drawnow;
            title(['Flow for the link id "', s.getLinkNameID{link_indices},'"']);
            xlabel('Time (h)'); 
            ylabel(['Flow (', s.LinkFlowUnits,')']);
            
            % Tank Volume
            figure (2);
            plot((t/3600), V(:,node_indices));
            drawnow;
            title(['Flow for the node id "', s.getNodeNameID{node_indices},'"']);
            xlabel('Time (h)'); 
            ylabel(['Volume (', s.NodeTankVolumeUnits,')']);
    end
    
    % Next hour
    h = h + 60;
end