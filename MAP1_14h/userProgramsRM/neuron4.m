function neuron4
% GeneralPurpose program for exploring auditory brainstem function
clear all
clc
addpath(['..' filesep 'utilities'])
showSynapses=1;

% cell descriptions are stored in function McGparameters
% *All* information about cells is contained in 'params'
params=McGparameters;

% load 'spikeSample.mat'
load 'AN.mat'
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

% Assumes that the alphaFunctions will be small after 5 ms.
%  for speed, they all have to be the same length
alphaFunctionDuration=.01;
timeAlphaFunction=dtSpikes:dtSpikes:alphaFunctionDuration;
units=struct('name',{},'ear',{},'params',{},'neuronParameters',{}, ...
    'quantity',{},'spikesMatrixLocations',{}, 'cellLocation', {},...
    'inputSources',{}, 'inputNames',{},'currentPerSpike',{}, ...
    'dendriteLPfreq',{});

%% establish unit structure - information on each cell type
spikesMatrixIDs=[]; cellLocationIDs=[];

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

        units(ear,typeNo).name=myParams.unitTypeNames;
        units(ear,typeNo).ear=earNames{ear};
        units(ear,typeNo).params=myParams;
        nCells=myParams.nCells;
        units(ear,typeNo).quantity= nCells;
        units(ear,typeNo).neuronParameters= neuronParameters;
        
        % allocation of cell location numbers is incremental
        units(ear,typeNo).spikesMatrixLocations= ...
            spikesMatrixLocation:spikesMatrixLocation+nCells-1;
        spikesMatrixLocation=spikesMatrixLocation+nCells;
        % spikesMatrixIDs & cellLocationIDs allow identity recovery from a
        % knowledge of the row number of the spikes or the cell matrix.
        spikesMatrixIDs=[spikesMatrixIDs; repmat([ear typeNo],nCells,1)];
        
        if typeNo>1
            cellLocations= ...
                units(ear,typeNo).spikesMatrixLocations-nANfibers;
            units(ear,typeNo).cellLocations=cellLocations;
            % cellLocationIDs are [ear type]pairs
            cellLocationIDs= [cellLocationIDs; repmat([ear typeNo],nCells,1)];
            
        end
        
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

% establish neuron parameters separately for each cell
nParams=length(neuronParameters);
nCellLocations=size(cellLocationIDs,1);
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

%% establish synapse data
alphaFunctions=[];
alphaFunctionCount=0;
synapseData=[];
synapseCount=0;
[nEars, nCelltypes]=size(units);
for typeNo=2:nCelltypes     % ignore AN when locating cells
    for ear=1:nEars
        nCells= units(ear,typeNo).quantity;
        cellLocations= units(ear,typeNo).cellLocations;
        
        inputSources= units(ear,typeNo).inputSources;
        nSources=size(inputSources,1);
        
%         Iarray=[];
        currentsPerSpike=units(ear,typeNo).currentPerSpike;
        dendriteLPfreqs=units(ear,typeNo).dendriteLPfreq;
        
        for sourceNo=1:nSources
            inputIDs=inputSources(sourceNo,:); % ith [ear type quntity]
            currentPerSpike=currentsPerSpike(sourceNo);
            % go look for the input sources
            % inputIDs(1)=ear, inputIDs(2)= cell type
            % locations refer to spike matrix
            inputPossibilities= units(inputIDs(1),inputIDs(2))...
                .spikesMatrixLocations;
            nInputPossibilities= length(inputPossibilities);
            inputLocs{sourceNo}= inputPossibilities ;
            
            currents=repmat(currentPerSpike,1, ...
                length(inputPossibilities));
%             Iarray=[Iarray; currents];
            
            % each *type* of input has its own alpha function
            spikeToCurrentTau=1/(2*pi*dendriteLPfreq(sourceNo));
            alphaFunctions= [alphaFunctions;
                (currentPerSpike / ...
                spikeToCurrentTau)*timeAlphaFunction ...
                .*exp(-timeAlphaFunction/spikeToCurrentTau)];
            alphaFunctionCount=alphaFunctionCount+1;
            
            nSynapses= inputSources(sourceNo,3);
            for cellNo=1:nCells
                % locations refer to cells (not spikeMatrix)
                cellLocation= cellLocations(cellNo);
                
                for synapseNo=1:nSynapses
                    sourceLocation= inputPossibilities ...
                        (ceil(nInputPossibilities*rand(1,1)));
                    synapseData=  [synapseData; ...
                        [sourceLocation cellLocation ...
                        alphaFunctionCount currentsPerSpike(sourceNo)]];
                    
                end % synapse
            end     % cell
            units(ear,typeNo).inputLocs=inputLocs;
%             units(ear,typeNo).Iarray=Iarray;
        end         % sources
    end             % ears
end                 % cellType

if showSynapses
    nSynapses=size(synapseData,1);
    disp(['synapse source:  ear     type    target: ear      type    ' ...
        'alphaNo  current'])
    for synapseNo=1:nSynapses
        %     disp(num2str([synapseNo synapseData(synapseNo,:)]))
        receivingCellLocation= synapseData(synapseNo,2);
        receivingCell= cellLocationIDs(receivingCellLocation,:);
        receivingEarNo= receivingCell(1);
        receivingCellTypeNo= receivingCell(2);
        receivingEarName= earNames{receivingEarNo};
        receivingTypeName= unitTypeNames{receivingCellTypeNo};
        
        sourceCellLocation= synapseData(synapseNo,1);
        sourceCell= spikesMatrixIDs(sourceCellLocation,:);
        sourceEarNo= sourceCell(1);
        sourceCellTypeNo= sourceCell(2);
        sourceEarName= earNames{sourceEarNo};
        sourceTypeName= unitTypeNames{sourceCellTypeNo};
        
        alphaFunctionCount=synapseData(synapseNo,3);
        current=1e9*synapseData(synapseNo,4);
        
        fprintf('%6.0f\t\t%s\t%s\t\t%s\t%s\t%3.0f\t%4.0f\n', synapseNo, ...
            sourceEarName, sourceTypeName, ...
            receivingEarName, receivingTypeName, ...
            alphaFunctionCount, current)
    end
    disp(['synapse source:  ear     type    target: ear      type    ' ...
        'alphaNo  current'])
    fprintf('\n')
    disp([num2str(nSynapses) ' synapses'])
end

% display function only
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
%             Iarray=1e9*units(ear,typeNo).Iarray;
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
%                 disp(   num2str(Iarray(i,:)))
            end
        end
        disp('__________')
    end
end


fprintf('\n')
disp(['total spikesMatrixLocations = ' num2str(lastLocation)])
fprintf('\n')

%% final computations to find cell action potentials
nCellLocations=size(cellLocationIDs,1);
cellSpikesMatrix=false(nCellLocations,nEpochs);
spikesMatrix=[ANoutput; cellSpikesMatrix]; 

plotInstructions=[];
numTypes=size(units,2);
numFigRows=numTypes+2;
numFigCols=2;
rds=2;  % raster dot size

figure(10),
subplot(numFigRows,numFigCols,1)
plotInstructions.axes=gca;
% plotInstructions.figureNo=1;
plotInstructions.displaydt=dtSpikes;
plotInstructions.title= 'spikes matrix (initial)';
plotInstructions.xLabel= 'time';
plotInstructions.yLabel= 'cellNo';
plotInstructions.plotColor='k';
plotInstructions.rds=2;
UTIL_plotMatrix(flipud(spikesMatrix), plotInstructions);
rows=size(spikesMatrix,1);




[spikesMatrix, membranePotential, dendriticCurrent]= neuron ...
    (spikesMatrix, dtSpikes, synapseData, alphaFunctions,allNeuronParameters);

plotInstructions=[];
figure(10),
subplot(numFigRows,numFigCols,2)
plotInstructions.axes=gca;
plotInstructions.displaydt=dtSpikes;
plotInstructions.title= 'spikes matrix (final)';
plotInstructions.xLabel= 'time';
plotInstructions.yLabel= 'cellNo';
plotInstructions.plotColor='k';
plotInstructions.rds=2;
UTIL_plotMatrix(flipud(spikesMatrix), plotInstructions);

figure(10),
subplot(numFigRows,numFigCols,3)
dendriticCurrent=round(dendriticCurrent*1e12);
imagesc(dendriticCurrent);
ylabel('cell no')
title('dendriticCurrent')

figure(10),
subplot(numFigRows,numFigCols,4)
membranePotential=round(membranePotential*100);
imagesc(membranePotential);
ylabel('cell no')
title('membranePotentials')

figure(10),
subplot(numFigRows,numFigCols,5)
t=dtSpikes:dtSpikes:alphaFunctionDuration;
plot(t,alphaFunctions')
title('alphaFunctions')
ylabel('current strength')
xlabel('time')

plotInstructions=[];
figure(10),
subplot(numFigRows,numFigCols,6)
plotInstructions.axes=gca;
plotInstructions.displaydt=dtSpikes;
plotInstructions.title= 'ANoutput';
plotInstructions.xLabel= 'time';
plotInstructions.yLabel= 'L/R fiber no';
plotInstructions.plotColor='k';
plotInstructions.rds=2;
UTIL_plotMatrix(flipud(ANoutput), plotInstructions);

% Cell output
for unit=3:numel(units)
    spikesMatrixLocations=units(unit).spikesMatrixLocations;
    cellName=units(unit).name;
    ear=units(unit).ear;
    cellResponse= spikesMatrix(spikesMatrixLocations,:);
    figure(10),
    subplot(numFigRows,numFigCols,6+unit-2)
    plotInstructions.axes=gca;
    plotInstructions.displaydt=dtSpikes;
    plotInstructions.title= [cellName ': ' ear];
    plotInstructions.xLabel= 'time';
    plotInstructions.yLabel= 'cell no';
    plotInstructions.plotColor='k';
    plotInstructions.rds=5;
    x=false(1,size(cellResponse,2));
UTIL_plotMatrix(flipud([x; cellResponse; x]), plotInstructions);

% cell label (allow for spacer rows top and bottom)
rows=size(cellResponse,1);
if rows>1
    set(gca,'YTick', [2 rows-1])
    set(gca,'YTickLabel',{'1', num2str(rows)})
else
    set(gca,'YTick', [2 ])
    set(gca,'YTickLabel',{'1'})
end
end

return


%%
function [spikesMatrix, membranePotential, dendriticCurrent]= neuron ...
    (spikesMatrix, dtSpikes, synapseData,alphaFunctions, allNeuronParameters)

% Input:
%  spikesMatrix: includes AN inputs at the top of the matrix
%   the initial matrix contains ANinput and empty cell responses
%  dtSpikes: is determined by the AN response array
%  synapseData: one row per synapse
%   sourceLocation cellLocation alphaFunctionCount currentPerSpike
%  alphafunctions: table of functions identified in synapseData
%  allNeuronParameters: separate row of parameters for each cell
%
% spikesMatrix: updated version of the input. Cell activity added to AN
% membranePotential: applies only to cells and is created here


[nSpikesRows, nEpochs]=size(spikesMatrix);
nCells=size(allNeuronParameters,1);
nANfibers=nSpikesRows-nCells;
nSynapses=size(synapseData,1);

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

alphaFunctionLength=length(alphaFunctions(1,:));
dendriticCurrent=zeros(nCells, nEpochs+ alphaFunctionLength);
membranePotential=Er(1)*ones(nCells,nEpochs);   % set to resting (not zero)

% variables
E=zeros(nCells,1);
Gk=zeros(nCells,1);
Th=Th0.*ones(nCells,1);
synapseDelay=round(0.002/dtSpikes);

% interauralDelay=1./(8*BF);
for t=synapseDelay+1:nEpochs
    % establish the state of current input at time t
    % inouts always arrive late
    spikesNow=spikesMatrix(:,t-synapseDelay);
    for synapseNo=1:nSynapses
        currentSourceNo=synapseData(synapseNo,1);
        spikingAction=spikesNow(currentSourceNo);
        if spikingAction
            currentTargetNo=synapseData(synapseNo,2);
            dendriticAction= alphaFunctions(synapseData(synapseNo,3),:);
            
            dendriticCurrent(currentTargetNo,t:t+alphaFunctionLength-1)= ...
                dendriticCurrent(currentTargetNo,t:t+alphaFunctionLength-1) ...
                + dendriticAction;
        end
    end
    
    dE= (-E./tauM +dendriticCurrent(:,t)./cap +(Gk./cap).*(Ek-E))*dtSpikes;
    
    E=E+dE;
    s=E>Th;
    membranePotential(:,t)=E+s.*(Eb-E)+Er;
    spikes=membranePotential(:,t)>-0.01;
    % disallow spike if already spiking
    spikes(spikesMatrix(spikes,t-1)>0)=0;
    % these now act as inputs to other cells
    spikesMatrix(nANfibers+1:nCells+nANfibers,t)=spikes';
    
    dGk=-Gk*dtSpikes./tauGk +dGkSpike.*s;
    Gk=Gk+dGk;
    
    % After a spike, the threshold is raised
    % otherwise it settles to its baseline
    dTh=-(Th-Th0)*dtSpikes./tauTh +s.*ThShift;
    Th=Th+dTh;
    
end         % time
% savedNeuronStatus=[E Gk Th cap tauM Ek dGkSpike tauGk Th0 ThShift tauTh Er Eb];


function allParams=McGparameters
count=0;
%% AN  #1
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

%% CN bushy #2
params.unitTypeNames = 'CN(primary-like)';
params.nCells=	20;                         % N neurons per BF
% [[ear input_cell_ID no_of_inputs];[ear input_cell_ID no_of_inputs]]
params.inputSources=[[0 1 2]; [0 3 10]];
params.currentPerSpike= [200e-9  -100e-9];  % current on dendrite per input
params.dendriteLPfreq=[500 50];             % (per source)
params.Cap=4.55e-9;                         % cell capacitance (Farads)
params.tauM=5e-4;                           % membrane time constant (s)
params.Ek=-0.01;                            % K+ equil. potential (V)
params.dGkSpike=3.64e-5;        % K+ conductance shift after a spike,S
params.tauGk=	0.0012;         % K+ conductance tau (s)
params.Th0=	0.01;               % spiking threshold (V)
params.ThShift=	0.01;           % threshold voltage shift on spike,S.
params.tauTh=	0.015;          % threshold shift time constant
params.Er=-0.06;                % resting potential (V)
params.Eb=0.06;                 % spike height above resting (V)
count=count+1; allParams{count}=params;

%% CN chopper #3
params.nCells=	20;                         % N neurons per BF
params.unitTypeNames = 'CN(chopT)';
% [[ear input_cell_ID no_of_inputs];[ear input_cell_ID no_of_inputs]]
params.inputSources=[0 1 10];  
params.currentPerSpike=23e-9;               % current on dendrite per input
params.dendriteLPfreq=50;                   % (per source)
params.Cap=1.67e-8;                         % cell capacitance (Farads)
params.tauM=0.002;                          % membrane time constant (s)
params.Ek=-0.01;                % K+ equil. potential (V)
params.dGkSpike=1.33e-4;        % K+ conductance shift after a spike,S
params.tauGk=	0.002;          % K+ conductance tau (s)
params.Th0=	0.01;               % spiking threshold (V)
params.ThShift=	0;              % threshold voltage shift on spike,S.
params.tauTh=	0.02;           % threshold shift time constant
params.Er=-0.06;                % resting potential (V)
params.Eb=0.06;                 % spike height above resting (V)

count=count+1; allParams{count}=params;

%% MSO bushy #4
% need to specify contralateral delay for opp ear inputs
params.unitTypeNames = 'MSO(primary-like)';
params.nCells=	20;   % N neurons per BF
% [[ear input_cell_ID no_of_inputs];[ear input_cell_ID no_of_inputs]]
params.inputSources=[[0 2 1];[-1 2 1]];
params.currentPerSpike=[200e-9 200e-9]; 
params.dendriteLPfreq=[500 500]; 
params.Cap=4.55e-9;   
params.tauM=5e-4;    
params.Ek=-0.01;      
params.dGkSpike=3.64e-5; 
params.tauGk=	0.0012; 
params.Th0=	0.01;   
params.ThShift=	0.01;
params.tauTh=	0.015;
params.Er=-0.06;      
params.Eb=0.06;

count=count+1; allParams{count}=params;


%% IC chopper #5
params.nCells=	1;   % N neurons per BF
params.unitTypeNames = 'IC(chopper)';
% [[ear input_cell_ID no_of_inputs];[ear input_cell_ID no_of_inputs]]
params.inputSources=[[0 4 20]];  
params.currentPerSpike=[50e-9]; 
params.dendriteLPfreq=50;   
params.Cap=1.67e-8; 
params.tauM=0.002; 
params.Ek=-0.01;    
params.dGkSpike=1.33e-4; 
params.tauGk=	0.002;
params.Th0=	0.01; 
params.ThShift=	0;        
params.tauTh=	0.02; 
params.Er=-0.06;    
params.Eb=0.06;     

count=count+1; allParams{count}=params;

%% IC chopper (difference cells) #6
params.nCells=	1;   % N neurons per BF
params.unitTypeNames = 'IC(chopperDiff)';
% [[ear input_cell_ID no_of_inputs];[ear input_cell_ID no_of_inputs]]
params.inputSources=[[0 4 20]; [-1 4 20]];  
params.currentPerSpike=[50e-9 -50e-9]; 
params.dendriteLPfreq=[50 50];
params.Cap=1.67e-8; 
params.tauM=0.002;  
params.Ek=-0.01;    
params.dGkSpike=1.33e-4; 
params.tauGk=	0.002;
params.Th0=	0.01; 
params.ThShift=	0;
params.tauTh=	0.02; 
params.Er=-0.06;    
params.Eb=0.06;

count=count+1; allParams{count}=params;
