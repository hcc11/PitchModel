function neuron3
clear all

params=McGparameters;

load 'spikeSample.mat'
% ANoutput is left and right inputs
[nANfibers, nEpochs]=size(ANoutput);
duration=nEpochs*dtSpikes;

ears={'left','right'};
nEars=length(ears);


unitTypeNames={'AN', 'CNbushy', 'MSO', 'ICch'};
nCells=[nANfibers 20 20 1];
% nUnitTypes=length(unitTypeNames);
% unitInputs={{},{[1]},{[2]}, {[3]}};

locNo=1;
for ear=1:nEars
    oppEar=mod(ear+2,2)+1;
    
    %     'AN'
    typeNo=1;
    units(ear,typeNo).ear=ears(ear);
    units(ear,typeNo).name=unitTypeNames(typeNo);
    units(ear,typeNo).quantity= ...
        nCells(typeNo);
    units(ear,typeNo).params=params{typeNo};
    units(ear,typeNo).locations= ...
        locNo:locNo+nCells(typeNo)-1;
    locNo=locNo+nCells(typeNo);
    % no inputs for AN
    units(ear,typeNo).nInputTypes=0;
    units(ear,typeNo).inputNames={};
    units(ear,typeNo).inputIDnos=[];
    units(ear,typeNo).nInputTypes= 0;
    units(ear,typeNo).inputPolarity= [];
    
    % 'CNbushy'
    typeNo=typeNo+1;
    units(ear,typeNo).ear=ears(ear);
    units(ear,typeNo).name=unitTypeNames(typeNo);
    units(ear,typeNo).quantity= ...
        nCells(typeNo);
    units(ear,typeNo).params=params{typeNo};
    units(ear,typeNo).locations= ...
        locNo:locNo+nCells(typeNo)-1;
    locNo=locNo+nCells(typeNo);
    %[ [ear cell]; [ear cell] ]
    inputIDnos= [ear,1]; % (i.e. 'AN')
    inputPolarity=1; % (i.e. excitatory)
    units(ear,typeNo).inputIDnos=inputIDnos;
    units(ear,typeNo).nInputTypes= size(inputIDnos,1);
    units(ear,typeNo).inputNames=...
        unitTypeNames(inputIDnos(:,2));
    units(ear,typeNo).inputPolarity=...
        inputPolarity;
    units(ear,typeNo).currentPerSpike=...
        [90e-9];
    
    %     'MSO'
    typeNo=typeNo+1;
    units(ear,typeNo).name=unitTypeNames(typeNo);
    units(ear,typeNo).ear=ears(ear);
    units(ear,typeNo).quantity= ...
        nCells(typeNo);
    units(ear,typeNo).params=params{typeNo};
    units(ear,typeNo).locations= ...
        locNo:locNo+nCells(typeNo)-11;
    locNo=locNo+nCells(typeNo);
    %[ [ear cell]; [ear cell] ]
    inputIDnos= [[ear 2]; [oppEar 2]]; % (i.e. 'CNbushy')
    inputPolarity=[ 1 1]; % (i.e. excitatory excitatory)
    units(ear,typeNo).inputIDnos=inputIDnos;
    units(ear,typeNo).nInputTypes= size(inputIDnos,1);
    units(ear,typeNo).inputNames=...
        unitTypeNames(inputIDnos(:,2));
    units(ear,typeNo).inputPolarity=...
        inputPolarity;
    units(ear,typeNo).currentPerSpike=...
        [100e-9 100e-9];
    
    %     'ICch'
    typeNo=typeNo+1;
    units(ear,typeNo).name=unitTypeNames(typeNo);
    units(ear,typeNo).ear=ears(ear);
    units(ear,typeNo).quantity=  nCells(typeNo);
    units(ear,typeNo).params=params{typeNo};
    units(ear,typeNo).locations= locNo:locNo+nCells(typeNo)-1;
    locNo=locNo+nCells(typeNo);
    %[ [ear cell]; [ear cell] ]
    inputIDnos= [[ear 3]; [oppEar 3]]; % (i.e. MSO)
    inputPolarity=[1 -1]; % (i.e. excitatory)
    units(ear,typeNo).inputIDnos=inputIDnos;
    units(ear,typeNo).nInputTypes= size(inputIDnos,1);
    units(ear,typeNo).inputNames= unitTypeNames(inputIDnos(:,2));
    units(ear,typeNo).inputPolarity= inputPolarity;
    units(ear,typeNo).currentPerSpike= [90e-9 90e-9];
    
end

[a, b]=size(units);
for ear=1:a
    for typeNo=1:b
        inputLocs=[];
        Iarray=[];
        nIDs= units(ear,typeNo).nInputTypes;
        if nIDs>0
            % the inputs come from here ([ear typeNo])
            inputIDnos= units(ear,typeNo).inputIDnos;
            for i=1:nIDs
                inputIDs=inputIDnos(i,:);
                locs=units(inputIDs(1),inputIDs(2)).locations;
                inputLocs=[inputLocs locs ];
                cps=units(ear,typeNo).currentPerSpike;
                types=units(ear,typeNo).inputPolarity;
                thisType=types(i)*cps(i);
                types=repmat(thisType,1,length(locs));
                Iarray=[Iarray types];
            end
            units(ear,typeNo).inputLocs=inputLocs;
            units(ear,typeNo).Iarray=Iarray;
        end
    end
end


clc
[a, b]=size(units);
for ear=1:a
    for typeNo=1:b
        fprintf('\n')
        disp( units(ear,typeNo))
        nIDs= units(ear,typeNo).nInputTypes;
        if nIDs>0
            inputIDnos= units(ear,typeNo).inputIDnos;
            disp(ears(inputIDnos(:,1)))
            names=units(ear,typeNo).inputNames;
            disp(unitTypeNames(inputIDnos(:,2)))
            currentPerSpike=units(ear,typeNo).currentPerSpike;
            inputPolarity=units(ear,typeNo).inputPolarity;
            fprintf('nA %6.0f %6.0f %6.0f %6.0f %6.0f ', ...
                inputPolarity.*(1e9*currentPerSpike))
            fprintf('\n\n')
            
        end
        disp('input locations')
        disp(num2str(units(ear,typeNo).inputLocs))
        disp(num2str(1e9*units(ear,typeNo).Iarray))
        disp('__________')
    end
end

function allParams=McGparameters

count=0;

%% AN
params.unitTypeNames='AN';
params.nCells=	0;   % N neurons per BF
params.inputIDnos=[[0 3]; [-1 3]];  % N input fibers
params.currentPerSpike=[]; % *per spike
params.dendriteLPfreq=0;   % dendritic filter
params.Cap=0; % ??cell capacitance (Siemens)
params.tauM=0;  % membrane time constant (s)
params.Ek=0;    % K+ eq. potential (V)
params.dGkSpike=0; % K+ cond.shift on spike,S
params.tauGk=	0;% K+ conductance tau (s)
params.Th0=	0; % equilibrium threshold (V)
params.c=	0;        % threshold shift on spike, (V)
params.tauTh=	0; % variable threshold tau
params.Er=0;    % resting potential (V)
params.Eb=0;     % spike height (V)
count=count+1; allParams{count}=params;

%% CN bushy
params.unitTypeNames = 'CN_bushy';
params.nCells=	20;   % N neurons per BF
params.inputIDnos=[0 1];   % N input fibers
params.currentPerSpike=100e-9; % (A) per spike
params.dendriteLPfreq=500;  % dendritic filter
params.Cap=4.55e-9;   % cell capacitance (Siemens)
params.tauM=5e-4;     % membrane time constant (s)
params.Ek=-0.01;      % K+ eq. potential (V)
params.dGkSpike=3.64e-5; % K+ cond.shift on spike,S
params.tauGk=	0.0012; % K+ conductance tau (s)
params.Th0=	0.01;   % equilibrium threshold (V)
params.c=	0.01;       % threshold shift on spike, (V)
params.tauTh=	0.015;  % variable threshold tau
params.Er=-0.06;      % resting potential (V)
params.Eb=0.06;       % spike height (V)
count=count+1; allParams{count}=params;

%% MSO bushy
params.unitTypeNames = 'MSO_PL';
params.nCells=	20;   % N neurons per BF
params.inputIDnos=[[0 2];[-1 2]];   % N input fibers
params.currentPerSpike=[100e-9 100e-9]; % (A) per spike
params.dendriteLPfreq=500;  % dendritic filter
params.Cap=4.55e-9;   % cell capacitance (Siemens)
params.tauM=5e-4;     % membrane time constant (s)
params.Ek=-0.01;      % K+ eq. potential (V)
params.dGkSpike=3.64e-5; % K+ cond.shift on spike,S
params.tauGk=	0.0012; % K+ conductance tau (s)
params.Th0=	0.01;   % equilibrium threshold (V)
params.c=	0.01;       % threshold shift on spike, (V)
params.tauTh=	0.015;  % variable threshold tau
params.Er=-0.06;      % resting potential (V)
params.Eb=0.06;       % spike height (V)

count=count+1; allParams{count}=params;


%% IC chopper
params.nCells=	2;   % N neurons per BF
params.unitTypeNames = 'IC_chopper';
params.inputIDnos=[[0 3]; [-1 3]];  % N input fibers
params.currentPerSpike=[90e-9 -90e-9]; % *per spike
params.dendriteLPfreq=150;   % dendritic filter
params.Cap=1.67e-8; % ??cell capacitance (Siemens)
params.tauM=0.002;  % membrane time constant (s)
params.Ek=-0.01;    % K+ eq. potential (V)
params.dGkSpike=1.33e-4; % K+ cond.shift on spike,S
params.tauGk=	0.002;% K+ conductance tau (s)
params.Th0=	0.01; % equilibrium threshold (V)
params.c=	0;        % threshold shift on spike, (V)
params.tauTh=	0.02; % variable threshold tau
params.Er=-0.06;    % resting potential (V)
params.Eb=0.06;     % spike height (V)

count=count+1; allParams{count}=params;
