clear;
close('all');

start_toolkit;
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
tstep=1; F=[]; t=[]; min = [];
h = 0;

link_names = {'12'};
link_indices = s.getLinkIndex(link_names);

for x = 1:i
    dosis = coagulantFunc(Ti(x), Ci(x));
    dosisArray(x) = dosis;
    %pause(1)
    
    for y = (1+h):(60+h)
        % Nivel del tanque
        t(y) = s.runHydraulicAnalysis;
        ti = s.runHydraulicAnalysis;
        min(y) = y;
        
        F = [F; s.getLinkFlows];
        tstep = s.nextHydraulicAnalysisStep;
        
            figure (1);
            plot((t/3600), F(:,link_indices));
            drawnow;
            title(['Flow for the link id "', s.getLinkNameID{link_indices},'"']);
            xlabel('Time (h)'); 
            ylabel(['Flow (', s.LinkFlowUnits,')']);
            %ylim([0, 250]);
    end
    
    h = h + 60;
end