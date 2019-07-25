clear;
close('all');
clc;
start_toolkit;

% Using 2 dll files. Load 2 Input files.
arch = computer('arch');
pwdepanet = fileparts(which('epanet.m'));
if strcmpi(arch,'win64')
    LibEPANETpath = [pwdepanet,'/64bit/'];
elseif strcmpi(arch,'win32')
    LibEPANETpath = [pwdepanet,'/32bit/'];
end        
temp_lib_folder = [LibEPANETpath,'temp_lib/'];
mkdir(temp_lib_folder)
epanet2_tmp = [temp_lib_folder,'epanet2tmp.dll'];
dll_pathLib = [LibEPANETpath, 'epanet2.dll'];
header_pathLib = [LibEPANETpath, 'epanet2.h'];
try
    copyfile(dll_pathLib, epanet2_tmp);
    copyfile(header_pathLib, [temp_lib_folder,'epanet2tmp.h']);
catch
end

% Load a network
   % s = sedimentator
   % f = filter
s = epanet('Net00-new.inp', epanet2_tmp);
warning('off'); % ignore warnings
%f = epanet('Net11.inp');
warning('on');

% Variables to set
hours = 72; % h
qi_s = 75; % LPS
% NTUi_s

s.setLinkInitialStatus(7, 0);

% Changing initial q
% valveID = '15';
% valveIndex = s.getLinkIndex(valveID);
% s.setLinkInitialSetting(valveIndex, qi_s);
% valveID = '16';
% valveIndex = s.getLinkIndex(valveID);
% s.setLinkInitialSetting(valveIndex, qi_s);
% valveID = '27';
% valveIndex = s.getLinkIndex(valveID);
% s.setLinkInitialSetting(valveIndex, qi_s);
% valveID = '28';
% valveIndex = s.getLinkIndex(valveID);
% s.setLinkInitialSetting(valveIndex, qi_s);

% Changing initial NTU

% Getting control
%     s.setControls(1, 'LINK 6 OPEN IF NODE 2 ABOVE 4');
%     c = s.getControls(1)

% Hydraulic analysis using ENepanet binary file
% (This function ignore events)
s.setTimeSimulationDuration(hours*3600);
hyd_res = s.getComputedTimeSeries;

% Change time-stamps from seconds to hours
hrs_time = hyd_res.Time/3600;

s.openHydraulicAnalysis;
s.initializeHydraulicAnalysis;
tstep=1; F=[];
id = '10';
index = s.getLinkIndex(id);
status = [0 0 0 0 0 1 1 1 1 1 1 1 0 1 0 1 0 1 0 1 0 0 0 0 1 1];
i=1;
t = [];
s.setLinkInitialStatus(index, 1);

while (tstep>0)
    t(i) = s.runHydraulicAnalysis;
    ti = s.runHydraulicAnalysis;
    
    if (ti == 24*3600)
        a = 'IN'
        ti
        s.setLinkStatus(index ,1);
    end
    
    i=i+1;
    F = [F; s.getLinkFlows];
    tstep = s.nextHydraulicAnalysisStep;
end

s.closeHydraulicAnalysis;
F(:,index);
status;


link_names = {'3', '12', '10'};
link_indices = s.getLinkIndex(link_names)

for i=link_indices
    figure;
    plot((t/3600), F(:,i));
    title(['Flow for the link id "', s.getLinkNameID{i},'"']);
    xlabel('Time (h)'); 
    ylabel(['Flow (', s.LinkFlowUnits,')']);
    ylim([0, 160]);
end

% for k=hrs_time
%    k
% end

% Plot water flow for specific links (ID)
% link_names = {'3', '12', '10'};
% link_indices = s.getLinkIndex(link_names)
% 
% for i=link_indices
%     figure;
%     plot(hrs_time, hyd_res.Flow(:,i));
%     title(['Flow for the link id "', s.getLinkNameID{i},'"']);
%     xlabel('Time (h)'); 
%     ylabel(['Flow (', s.LinkFlowUnits,')']);
%     ylim([0, 160]);
% end

s.plot
%f.plot

% Unload library
s.unload
%f.unload

% Delete files who created
delete(epanet2_tmp);
delete([temp_lib_folder,'epanet2tmp.h']);
rmdir(temp_lib_folder);

%%  Para determinar el tiempo en la salida del sedimentador (tipo caudal)
%   v = 1/h * R^(2/3) * So^(1/2)
%   R = A/P
%   Q = v*A
%   Q = V/t

%   donde
%   v: velocidad
%   h: altura en el caudal (varía )
%   R: radio hidráulico
%   So: Inclinación (? (2% o más)
%   A: area o sección transversal (longitud x altura)
%   P: perímetro mojado (2h + L)
%   V: volumen

%   Para la salida de cada agujero
%   v = Cd*sqrt(2gh)

%   v: velocidad de salida
%   Cd: coeficiente de descarga, se supone 1 por el diseño físico de la
%   planta
%   g: gravedad
%   h: altura del líquido
%%  Para la carga del filtro, teniendo la medición de hf (Se debe determinar con qué diferencial se inicia el lavado)
%   hf = k*v^2/2*g      (darcy-w)
%   v = Q/A
%   Q = k*i*A
%   i = hf/L (¿quién es L en este caso? La diferencia de la ubicación de los piezo)    (darcy-w)

%   hf: perdida de carga
%   k: resistencia del filtro
%   v: velocidad
%   g: gravedad
%   Q: caudal
%   A: area transversal
%   i: corriente
%   L: distancia entre los piezometros
%% CONTROL RULES
% RULE 1
% IF SYSTEM CLOCKTIME = 7:30 AM
% THEN LINK 1 STATUS IS CLOSED
% AND VALVE 16 SETTING IS 150
% AND VALE 17 SETTING IS 150

% e.g.
% d.addControls(‘LINK 9 OPEN IF NODE 2 BELOW 110’)
% d.setControls(1, ‘LINK 9 CLOSED IF NODE 2 ABOVE 180’)
%% INFORMACIÓN

% But problem is TCV does not modeled as actual control valve. from the manual i have found its ...
%     actually a pipe element whose head loss is adjusted to restrict the flow. its value varied from 0 to 10^8. ...
%     0 refers no head loss and 10^8 refers extreme head loss so pipe is closed.
