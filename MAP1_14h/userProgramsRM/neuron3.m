function neuron3
% GeneralPurpose program for exploring auditory brainstem function
clear all
clc
addpath(['..' filesep 'utilities'])

% cell descriptions are stored in function McGparameters
% *All* information about cells is contained in 'params'
params=McGparameters;

load 'spikeSample.mat'
% ANoutput is left and right inputs
[nANfibers, nEpochs]=size(ANoutput);
% duration=nEpochs*dtSpikes;

% The number of input AN fibers is not defined until run time
%  Add this detail to params before exploring params in more detail
ANparams=params{1};
nANfibersPerEar=round(nANfibers/2);
ANparams.nCells=nANfibersPerEar;
params{1}=ANparams; % i.e. set the nCells parameter to nANfibers for AN

earNames={'left','right'};  % useful for some displays
nEars=length(earNames);

% It is useful when identifying the name of input sources
%  to have a list of names
unitTypeNames=cell(1,length(params));
for i=1:length(params)
    myParams=params{i};
    unitTypeNames{i}=myParams.unitTypeNames;
end

% At run time, all cells have a unique location number (locationNum)
%  in the spikes matrix
spikesMatrixLocation=1;

% Assumes that the alphaFunction will be small after 5 ms.
%  for speed, they all have to be the same length
alphaFunctionDuration=.005;
timeAlphaFunction=dtSpikes:dtSpikes:alphaFunctionDuration;
units=struct('name',{},'ear',{},'params',{},'neuronParameters',{}, ...
    'quantity',{},'spikesMatrixLocations',{}, 'cellLocation', {},...
    'inputSources',{}, 'inputNames',{},'currentPerSpike',{}, ...
    'dendriteLPfreq',{});

for typeNo=1:length(params)
    for ear=1:nEars
        oppEar=mod(ear+2,2)+1;  % opposite ear to 'ear'
        
        % collect information from params and store it
        myParams=params{typeNo};
        neuronParameters=[
            myParams.Cap
            myParams.tauM
            myParams.Ek
            myParams.dGkSpike
            myParams.tauGk
            myParams.Th0
            myParams.ThShift
            myParams.tauTh
            myParams.Er
            myParams.Eb
            ];
        %
        units(ear,typeNo).name=myParams.unitTypeNames;
        units(ear,typeNo).ear=earNames{ear};
        units(ear,typeNo).params=myParams;
        nCells=myParams.nCells;
        units(ear,typeNo).quantity= nCells;
        units(ear,typeNo).neuronParameters= neuronParameters;
        
        % allocation of cell location numbers is incremental
        units(ear,typeNo).spikesMatrixLocations= ...
            spikesMatrixLocation:spikesMatrixLocation+nCells-1;
        units(ear,typeNo).cellLocation= ...
            units(ear,typeNo).spikesMatrixLocations-nANfibers;
        
        spikesMatrixLocation=spikesMatrixLocation+nCells;
        
        % list of input cells and quantities
        %[ [ear cell num]; [ear cell num] ]
        inputSources= myParams.inputSources;
        
        if size(inputSources,1)>0
            % 0 and -1 code for ipsilateral and contralateral
            inputSources(inputSources(:,1)==0,1)=ear;
            inputSources(inputSources(:,1)==-1,1)=oppEar;
            units(ear,typeNo).inputSources=inputSources;
            units(ear,typeNo).inputNames= ...
                {unitTypeNames{inputSources(:,2)}};
            
            currentPerSpike=myParams.currentPerSpike;
            units(ear,typeNo).currentPerSpike= currentPerSpike;
            dendriteLPfreq=myParams.dendriteLPfreq;
            units(ear,typeNo).dendriteLPfreq=dendriteLPfreq;
            
        else
            % NB AN has no inputs
            units(ear,typeNo).inputNames=[];
            units(ear,typeNo).inputSources=[];
        end
    end
end
lastLocation=spikesMatrixLocation-1;

% Specify main computational arena
spikesMatrix=false(lastLocation,nEpochs);
spikesMatrix(1:nANfibers,1:nEpochs)=ANoutput; % left and right consecutive
% membranePotentialMatrix ignores ANfibers
nCellLocations=lastLocation-2*nANfibers;
membranePotentialMatrix=zeros(nCellLocations,nEpochs);

% establish neuron parameters separately for each cell
nParams=length(neuronParameters);
allNeuronParameters=zeros(nCellLocations,nParams);
cellCount=1;
for typeNo=2:length(params) % ignore AN inputs (not cells)
    for ear=1:nEars
        nCells=units(ear,typeNo).quantity;
        neuronParameters=units(ear,typeNo).neuronParameters;
        neuronParameters=repmat(neuronParameters',nCells,1);
        allNeuronParameters(cellCount:cellCount+nCells-1,:)= ...
            neuronParameters;
        cellCount=cellCount+nCells;
    end
end


% figure(1), clf
[a, b]=size(units);
for typeNo=1:b
    for ear=1:a
        %         nIDs= units(ear,typeNo).nInputTypes;
        inputSources= units(ear,typeNo).inputSources;
        if size(inputSources,1)>0 % at least some inputs to this cell
            % the inputs come from here ([ear type quntity])
            %  inputSources= units(ear,typeNo).inputSources;
            synapseLocations=[];
            Iarray=[];
            inputLocs=[];
            alphaFunction=[];
            % cell may have more than one input source
            for i=1:size(inputSources,1)
                inputIDs=inputSources(i,:); % ith [ear type quntity]
                % go look for the input sources
                % inputIDs(1)=ear, inputIDs(2)= cell type
                locs=units(inputIDs(1),inputIDs(2)).spikesMatrixLocations;
                % inputLocs is a list of possible input cell 
                %  spikesMatrixLocations, one list for each source
                inputLocs{i}= locs ;
                nInputLocs=numel(locs);
                % nSynapses is the quantity
                nCellsOfThistype=inputIDs(3);
                % for each input source there are many synapses
                for j=1:nCellsOfThistype;
                    % select at random an appropriate number of inputs
                    synapsesIDX=ceil(nInputLocs*(rand(nInputLocs,1)))';
                    synapseLocations{i,j}= locs(synapsesIDX);
                    
                end
                
                % all synapses for this source have the same strength
                currentPerSpike=units(ear,typeNo).currentPerSpike;
                currents=repmat(currentPerSpike(i),1,length(locs));
                Iarray=[Iarray; currents];
                
                % each *type* of input has its own alpha function
                dendriteLPfreq=units(ear,typeNo).dendriteLPfreq;
                spikeToCurrentTau=1/(2*pi*dendriteLPfreq);
                alphaFunction= [alphaFunction;
                    (currentPerSpike(i) / ...
                    spikeToCurrentTau)*timeAlphaFunction ...
                    .*exp(-timeAlphaFunction/spikeToCurrentTau)];
                %   plot(timeAlphaFunction,alphaFunction), hold on
                
            end
            % save matrices that have been accumulating
            units(ear,typeNo).alphaFunction=alphaFunction;
            units(ear,typeNo).inputLocs=inputLocs;
            units(ear,typeNo).synapseLocations=synapseLocations;
            units(ear,typeNo).Iarray=Iarray;
        else
            units(ear,typeNo).alphaFunction=[];
        end %if >1 source
    end
end

% display function only
clc
[a, b]=size(units);
for typeNo=1:b
    for ear=1:a
        fprintf('\n')
        disp( units(ear,typeNo))
        %         nIDs= units(ear,typeNo).nInputTypes;
        inputSources= units(ear,typeNo).inputSources;
        
        disp('cell spikesMatrixLocations:')
        disp(num2str(units(ear,typeNo).spikesMatrixLocations))
        fprintf('\n')
        if size(inputSources,1)>0
            Iarray=1e9*units(ear,typeNo).Iarray;
            names=units(ear,typeNo).inputNames;
            currentPerSpike=units(ear,typeNo).currentPerSpike;
            
            disp('input sources/ spikesMatrixLocations/ current per spike')
            inputLocs=units(ear,typeNo).inputLocs;
            for i=1:length(names)
                fprintf('\n')
                disp([
                    (earNames(inputSources(i,1)))  ...
                    (unitTypeNames(inputSources(i,2))) ])
                disp(   num2str(inputLocs{i}))
                disp(   num2str(Iarray(i,:)))
            end
        end
        disp('__________')
    end
end

% % raster display of cell connection matrix
% plotInstructions=[];
% %         subplot(5,2,2+sideCount)
% %         plotInstructions.axes=gca;
% plotInstructions.figureNo=1;
% plotInstructions.displaydt=dtSpikes;
% plotInstructions.title= ['cell connection matrix '];
% plotInstructions.plotColor='k';
% plotInstructions.rasterDotSize=2;
% UTIL_plotMatrix(flipud(spikesMatrix), plotInstructions);

fprintf('\n')
disp(['total spikesMatrixLocations = ' num2str(lastLocation)])
fprintf('\n')

% [spikesMatrix, membranePotential]= neuron ...
%      (spikesMatrix, dtSpikes, units,allNeuronParameters);

function allParams=McGparameters

count=0;

%% AN
params.unitTypeNames='AN';
params.nCells=	0;  % must be set after examening the AN input
params.inputSources=[];  % N input fibers
params.currentPerSpike=[]; % *per spike
params.dendriteLPfreq=0;   % dendritic filter
params.Cap=0; % ??cell capacitance (Siemens)
params.tauM=0;  % membrane time constant (s)
params.Ek=0;    % K+ eq. potential (V)
params.dGkSpike=0; % K+ cond.shift on spike,S
params.tauGk=	0;% K+ conductance tau (s)
params.Th0=	0; % equilibrium threshold (V)
params.ThShift=	0;        % threshold shift on spike, (V)
params.tauTh=	0; % variable threshold tau
params.Er=0;    % resting potential (V)
params.Eb=0;     % spike height (V)
count=count+1; allParams{count}=params;

%% CN bushy
params.unitTypeNames = 'CN_bushy';
params.nCells=	20;   % N neurons per BF
% [ear input_cell_ID no_of_inputs]
params.inputSources=[0 1 2];
params.currentPerSpike=100e-9; % (A) per spike
params.dendriteLPfreq=500;  % dendritic filter
params.Cap=4.55e-9;   % cell capacitance (Siemens)
params.tauM=5e-4;     % membrane time constant (s)
params.Ek=-0.01;      % K+ eq. potential (V)
params.dGkSpike=3.64e-5; % K+ cond.shift on spike,S
params.tauGk=	0.0012; % K+ conductance tau (s)
params.Th0=	0.01;   % equilibrium threshold (V)
params.ThShift=	0.01;       % threshold shift on spike, (V)
params.tauTh=	0.015;  % variable threshold tau
params.Er=-0.06;      % resting potential (V)
params.Eb=0.06;       % spike height (V)
count=count+1; allParams{count}=params;

%% MSO bushy
params.unitTypeNames = 'MSO_PL';
params.nCells=	20;   % N neurons per BF
% [ear input_cell_ID no_of_inputs]
params.inputSources=[[0 2 1];[-1 2 1]];
params.currentPerSpike=[100e-9 100e-9]; % (A) per spike
params.dendriteLPfreq=500;  % dendritic filter
params.Cap=4.55e-9;   % cell capacitance (Siemens)
params.tauM=5e-4;     % membrane time constant (s)
params.Ek=-0.01;      % K+ eq. potential (V)
params.dGkSpike=3.64e-5; % K+ cond.shift on spike,S
params.tauGk=	0.0012; % K+ conductance tau (s)
params.Th0=	0.01;   % equilibrium threshold (V)
params.ThShift=	0.01;       % threshold shift on spike, (V)
params.tauTh=	0.015;  % variable threshold tau
params.Er=-0.06;      % resting potential (V)
params.Eb=0.06;       % spike height (V)

count=count+1; allParams{count}=params;


%% IC chopper
params.nCells=	2;   % N neurons per BF
params.unitTypeNames = 'IC_chopper';
% [ear input_cell_ID no_of_inputs]
params.inputSources=[[0 3 20]; [-1 3 20]];  % N input fibers
params.currentPerSpike=[90e-9 -90e-9]; % *per spike
params.dendriteLPfreq=150;   % dendritic filter
params.Cap=1.67e-8; % ??cell capacitance (Siemens)
params.tauM=0.002;  % membrane time constant (s)
params.Ek=-0.01;    % K+ eq. potential (V)
params.dGkSpike=1.33e-4; % K+ cond.shift on spike,S
params.tauGk=	0.002;% K+ conductance tau (s)
params.Th0=	0.01; % equilibrium threshold (V)
params.ThShift=	0;        % threshold shift on spike, (V)
params.tauTh=	0.02; % variable threshold tau
params.Er=-0.06;    % resting potential (V)
params.Eb=0.06;     % spike height (V)

count=count+1; allParams{count}=params;

%%
function [spikesMatrix, membranePotential]= neuron ...
     (spikesMatrix, dtSpikes, units,allNeuronParameters)

% dtSpikes: is determined by the AN response array
% spikesMatrix: includes AN inputs at the top of the matrix
%  the initial matrix contains ANinput and empty cell responses
% membranePotential: applies only to cells and is created here
% neuronParameters: separate row of parameters for each cell
% units: is a complete description of each cell type


nEpochs=size(spikesMatrix,2);
nCells=size(allNeuronParameters,1);
dendriticCurrent=zeros(nCells,nEpochs+lengthAlphaFunctions);
membranePotential=Er(1)*ones(nCells,nEpochs);   % set to resting (not zero)

% Constants. Created using:
% neuronParameters=[
%     myParams.Cap
%     myParams.tauM
%     myParams.Ek
%     myParams.dGkSpike
%     myParams.tauGk
%     myParams.Th0
%     myParams.ThShift
%     myParams.tauTh
%     myParams.Er
%     myParams.Eb
%     ];

cap=allNeuronParameters(:,1);
tauM=allNeuronParameters(:,2);
Ek=allNeuronParameters(:,3);
dGkSpike=allNeuronParameters(:,4);
tauGk=allNeuronParameters(:,5);
Th0=allNeuronParameters(:,6);
ThShift=allNeuronParameters(:,7);
tauTh=allNeuronParameters(:,8);
Er=allNeuronParameters(:,9);
Eb= allNeuronParameters(:,10);

% variables
E=zeros(nCells,1);
Gk=zeros(nCells,1);
Th=Th0.*ones(nCells,1);
synapseDelay=round(0.02/dtSpikes);

for t=synapseDelay+1:nEpochs
SpikesNow=inputspikes(:,t);    
    for i=1:nCells
        % the sum of all spikesMatrix at time t featured in the input 
        % to the ith cell
        %  selectedSpikes(:,t)= sum(spikesMatrix(:,t-inputMatrix(:,i)));
        activeInputs=inputMatrix(:,i);
        availableInputs=1*spikesMatrix(:,t-synapseDelay);
        spikesIn= sum(availableInputs & activeInputs);
        
        inducedCurrent(i,:)=spikesIn*alphaFunctions(i,:);
    end
    dendriticCurrent(:,t:t+lengthAlphaFunctions-1)=...
        dendriticCurrent(:,t:t+lengthAlphaFunctions-1)+inducedCurrent;
    
    dE= (-E./tauM +dendriticCurrent(:,t)./cap +(Gk./cap).*(Ek-E))*dtSpikes;
        
    E=E+dE;
    s=E>Th;
    membranePotential(:,t)=E+s.*(Eb-E)+Er;
    spikes=membranePotential(:,t)>-0.01;
    % disallow spike if already spiking
    spikes(outputSpikes(spikes,t-1)>0)=0; 
    % these now act as inputs to other cells
    spikesMatrix(1:nCells,t)=spikes;
    
    dGk=-Gk*dtSpikes./tauGk +dGkSpike.*s;
    Gk=Gk+dGk;
    
    % After a spike, the threshold is raised
    % otherwise it settles to its baseline
    dTh=-(Th-Th0)*dtSpikes./tauTh +s.*ThShift;
    Th=Th+dTh;
end

cellSpikes=spikesMatrix(1:nCells,:);
% savedNeuronStatus=[E Gk Th cap tauM Ek dGkSpike tauGk Th0 ThShift tauTh Er Eb];

