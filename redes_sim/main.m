clear;
close('all');

global s 

% Init Epanet
start_toolkit;

% Load data
%load('TestWorkspace.mat');
[Ti, Ci, DSA, To, Co] = loadData();

% Variables to set

% Coagulation
i = length(Ti);
dosisArray = [];

% Sedimentation
s = epanet('Net2-sediment.inp');
hours = length(Ti); % h
qi1 = 150; % LPS
qi2 = 150; % LPS
h1 = 1;
h2 = 1;

% Initial q change

% Sediment 1
% qin
valveID1 = '2'; 
valveIndex = s.getLinkIndex(valveID1);
s.setLinkInitialSetting(valveIndex, qi1);
% qout
% valveID = '12';
% valveIndex = s.getLinkIndex(valveID);
% s.setLinkInitialSetting(valveIndex, qo1);

% Sediment 2
% qin
valveID2 = '13';
valveIndex = s.getLinkIndex(valveID2);
s.setLinkInitialSetting(valveIndex, qi2);
% qout
% valveID = '14';
% valveIndex = s.getLinkIndex(valveID);
% s.setLinkInitialSetting(valveIndex, qo2);

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

tstep=1; F=[]; t=[]; V=[]; h = 0; status = 'Normal'; valveset=[]; dosisArray=[]; TiArray=[];

for x = 1:i
    
    % Coagulant dosis
    [dosis, status] = coagulantFunc(Ti(x), Ci(x));
    
    %pause(1)
    
    % Tank level status
        % if (level >= max) then (open sludge discharge valve) % 523.4 m3
        % if (level <= min) then (close sludge discharge valve) % 407,9 m3
    for y = (1+h):(60+h)
        dosisArray(y) = dosis;
        TiArray(y) = Ti(x);
        CiArray(y) = Ci(x);
        
        if (x > 1)
            sedimentFunc(qi1, Ti(x), Ti(x-1));
        else 
            sedimentFunc(qi1, Ti(x), 1);
        end
        
        valveIndex = s.getLinkIndex(valveID1);
        valveset(x) = s.getLinkSettings(valveIndex);
        
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
            
            % Turbidity
            subplot(4,1,1);
            [haxes, hline1, hline2] = plotyy((t/3600), TiArray, (t/3600), CiArray);
            drawnow;
            title(['Turbidez']);
            ylabel(haxes(1), 'NTU');
            ylabel(haxes(2), 'UC');
            xlabel(haxes(2), 'Tiempo (h)');
%             xlim([0 96])
            
            % Dosage
            subplot(4,1,2);
            plot((t/3600), dosisArray, 'r');
            drawnow;
            title(['Dosis de Sulfato de Aluminio']);
            xlabel('Tiempo (h)'); 
            ylabel(['kg/h']);
%             xlim([0 96])
            
            % Flow
            subplot(4,1,3);
            plot((t/3600), F(:,link_indices));
            drawnow;
            title(['Flujo de salida sedimentador 1 "', s.getLinkNameID{link_indices},'"']);
            xlabel('Tiempo (h)'); 
            ylabel(['Flujo (', s.LinkFlowUnits,')']);
%           xlim([0 96])
            
            % Tank Volume
            subplot(4,1,4);
            plot((t/3600), V(:,node_indices));
            drawnow;
            title(['Volumen en el sedimentador 1 "', s.getNodeNameID{node_indices},'"']);
            xlabel('Tiempo (h)'); 
            ylabel(['Volumen (', s.NodeTankVolumeUnits,')']);
%             xlim([0 96])
%             ylim([0 510])
    end
    
    % Next hour
    h = h + 60;
end

