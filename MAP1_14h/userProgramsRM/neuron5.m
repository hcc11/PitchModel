function neuron5
% GeneralPurpose program for exploring binaural auditory brainstem function
% Circuits of unlimited complexity can be generated.
%
% Cell types are nominated in the function McGparameters along with details
%  of cell dynamics and lists of other cells supplying synaptic input.
%  Connections between cells can be unilateral of contralateral,
%  excitatory or inhibitory.
%
% Input comes from a .mat file containing binaural AN spiking patterns.
% Output is in the form of spiking patterns in all cells nominated 
%  presented as rater plots and PSTH with CV computation.
% The program is currently single-BF channel only.

clear all
clc
addpath(['..' filesep 'utilities'])
showSynapses=1;

% load 'spikeSample.mat'
load 'AN.mat'
% ANoutput is left and right inputs
[nANfibers, nEpochs]=size(ANoutput);
% duration=nEpochs*dtSpikes;

% cell descriptions are stored in function McGparameters
% *All* information about cells is contained in 'params'
params=McGparameters;

% The number of input AN fibers is not defined until run time
%  Add this detail to params(1)
ANparams=params{1};
nANfibersPerEar=round(nANfibers/2);
ANparams.nCells=nANfibersPerEar;
params{1}=ANparams; % i.e. set the nCells parameter to nANfibers for AN

earNames={'left','right'};  % useful for some displays
nEars=length(earNames);

% Extract a list of cell names mainly for clearer reporting.
unitTypeNames=cell(1,length(params));
cellCount=0;
for i=1:length(params)
    myParams=params{i};
    unitTypeNames{i}=myParams.unitTypeNames;
    cellCount=cellCount+myParams.nCells;
end
% left + right
totalCellCount=2*cellCount;

% AN fibers and cells each belong to 'types' and each type is associated
% with a lot of information.
% A unit is defined in terms of the type and the ear
units=struct('name',{},'ear',{},'params',{},'neuronParameters',{}, ...
    'quantity',{},'spikesMatrixLocations',{}, 'cellLocation', {},...
    'inputSources',{}, 'inputNames',{},'currentPerSpike',{}, ...
    'dendriteLPfreq',{});

% spiking element are AN fibers and cells
% Each element occupies a row in the spikesMatrix.
% spikesMatrixIDs (ear, type) say what kind of element is in each row
spikesMatrixIDs=zeros(totalCellCount, 2); 
spikesMatrixLocation=1;

% cellLocationIDs is similar but ignores AN fibers (they do not have
% input synapses)
cellLocationIDs=zeros(totalCellCount-nANfibers,2);

% each element may have many input synapses
% Each synapse is associated with a particular alpha function describing
% the rise and fall of current after receiving a spike.
% AlphaFunctions are all 10 ms long.
%  (For speed, they all have to be the same length)
alphaFunctionDuration=.01;
timeAlphaFunction=dtSpikes:dtSpikes:alphaFunctionDuration;


%% establish unit structure - information on each cell type
cellCount=0;
for typeNo=1:length(params)
    for ear=1:nEars
        % ears are 'left' or 'right'  
        % Inputs are either ipsilateral or contralateral.
        % Ipsi/contra must be interpreted in terms of which ear.
        oppEar=mod(ear+2,2)+1;  % opposite ear to 'ear'
        
        % Express unit parameters as a row vector (neuronParameters)
        %  so that they can be combined into a matrix for rapid processing
        % (allNeuronParameters)
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
        nCells=myParams.nCells; % i.e. nCells for this type for this ear
        units(ear,typeNo).quantity= nCells;
        units(ear,typeNo).neuronParameters= neuronParameters;
        
        % this ear/type combination occupies these rows in spikesMatrix
        units(ear,typeNo).spikesMatrixLocations= ...
            spikesMatrixLocation:spikesMatrixLocation+nCells-1;
        % spikesMatrixIDs allow (ear type) recovery from a
        % knowledge of the row number of the spikes or the cell matrix.
        spikesMatrixIDs(spikesMatrixLocation: ...
            spikesMatrixLocation+nCells-1, :)=repmat([ear typeNo],nCells,1);
        spikesMatrixLocation=spikesMatrixLocation+nCells;
        
        if typeNo>1
            cellLocations= ...
                units(ear,typeNo).spikesMatrixLocations-nANfibers;
            units(ear,typeNo).cellLocations=cellLocations;
            % cellLocationIDs are [ear type]pairs but for cells only
            cellLocationIDs(cellCount+1: cellCount+nCells,:)= ...
                repmat([ear typeNo],nCells,1);
            cellCount=cellCount+nCells;
        end
        
        % inputsources is a complete description of all inputs to this unit
        %  params.inputs= 
        %    [inputEar' inputCelltype' nInputs' currentPerspike' 
        %     dendriteLPfreq' synapticDelay'];
        % Each row is a different type of synapse
        inputSources= myParams.inputs;

        if size(inputSources,1)>0   % i.e. for each type of synapse
            % inputEar uses
            % 0 and -1 code for ipsilateral and contralateral
            % Replace first column of inputsources with appropriate *ear*
            inputSources(inputSources(:,1)==0,1)=ear;
            inputSources(inputSources(:,1)==-1,1)=oppEar;
            units(ear,typeNo).inputSources=inputSources;
            units(ear,typeNo).inputNames= ...
                {unitTypeNames{inputSources(:,2)}};
            
            currentPerSpike=inputSources(:,4);
            units(ear,typeNo).currentPerSpike= currentPerSpike;
            dendriteLPfreq=inputSources(:,5);
            units(ear,typeNo).dendriteLPfreq=dendriteLPfreq;
            
        else
            % NB AN has no inputs
            units(ear,typeNo).inputNames=[];
            units(ear,typeNo).inputSources=[];
        end
    end
end
lastLocation=spikesMatrixLocation-1;

% allNeuronParameters is a matrix of parameters whre each row represents a
% separate cell. This is vectorising to speed up neuronal computations
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
% There are many more synapses than cells.
% synapseData is use to determine the current input to the cell before the
% soma computations are attempted.

alphaFunctions=[];
alphaFunctionCount=0;
synapseData=[];
[nEars, nCelltypes]=size(units);

for typeNo=2:nCelltypes     % ignore AN when locating cells
    for ear=1:nEars
        nCells= units(ear,typeNo).quantity;
        cellLocations= units(ear,typeNo).cellLocations;
        
        inputSources= units(ear,typeNo).inputSources;
        nSources=size(inputSources,1);
        
        currentsPerSpike=inputSources(:,4);
        
        for sourceNo=1:nSources
            ear1Type2=inputSources(sourceNo,1:2); % ith [1=ear 2=inputType]
            currentPerSpike=currentsPerSpike(sourceNo);
            % each *type* of input has its own alpha function
            spikeToCurrentTau=1/(2*pi*dendriteLPfreq(sourceNo));
            alphaFunctions= [alphaFunctions;
                (currentPerSpike / ...
                spikeToCurrentTau)*timeAlphaFunction ...
                .*exp(-timeAlphaFunction/spikeToCurrentTau)];
            alphaFunctionCount=alphaFunctionCount+1;
            
            % go look for the input sources
            % ear1Type2(1)=ear, ear1Type2(2)= cell type
            % locations refer to spike matrix
            inputPossibilities= units(ear1Type2(1),ear1Type2(2))...
                .spikesMatrixLocations;
            % inputPossibilities are candidate input cells
            nInputPossibilities= length(inputPossibilities);
            inputLocations{sourceNo}= inputPossibilities ;
                        
            % each source has its own synaptic delay
            synapticDelay=inputSources(sourceNo, 6);

            nSynapses= inputSources(sourceNo,3);
            for cellNo=1:nCells
                % locations refer to cells (not spikeMatrix)
                cellLocation= cellLocations(cellNo);
                
                % select actual inputs at random from the possibilities
                for synapseNo=1:nSynapses
                    sourceLocation= inputPossibilities ...
                        (ceil(nInputPossibilities*rand(1,1)));
                    % comprehensive description of each synapse
                    synapseData=  [synapseData; ...
                        [sourceLocation cellLocation ...
                        alphaFunctionCount currentsPerSpike(sourceNo) ...
                        synapticDelay]];
                    
                end % synapse
            end     % cell
            units(ear,typeNo).inputLocations=inputLocations;

        end         % sources
    end             % ears
end                 % cellType

%% report all synapse details
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

% Report all cell type details
[a, b]=size(units);
for typeNo=1:b
    for ear=1:a
        fprintf('\n')
        disp( units(ear,typeNo))

        inputSources= units(ear,typeNo).inputSources;
        
        disp('cell spikesMatrixLocations:')
        disp(num2str(units(ear,typeNo).spikesMatrixLocations))
        fprintf('\n')
        if size(inputSources,1)>0
            names=units(ear,typeNo).inputNames;
            currentPerSpike=units(ear,typeNo).currentPerSpike;
            
            disp('input sources/ spikesMatrixLocations/ current per spike')
            inputLocations=units(ear,typeNo).inputLocations;
            for i=1:length(names)
                fprintf('\n')
                disp([
                    (earNames(inputSources(i,1)))  ...
                    (unitTypeNames(inputSources(i,2))) ])
                disp(   num2str(inputLocations{i}))
            end
        end
        disp('__________')
    end
end


fprintf('\n')
disp(['total spikesMatrixLocations = ' num2str(lastLocation)])
fprintf('\n')


%%  Chart displays and analysis of cell activity 

nCellLocations=size(cellLocationIDs,1);
cellSpikesMatrix=false(nCellLocations,nEpochs);
spikesMatrix=[ANoutput; cellSpikesMatrix]; 

plotInstructions=[];
numTypes=size(units,2);
numFigRows=numTypes+2;
numFigCols=2;
rds=2;  % raster dot size

% initial spikesMatrix
figure(10), clf
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

% McGregor computations
[spikesMatrix, membranePotential, dendriticCurrent]= neuron ...
    (spikesMatrix, dtSpikes, synapseData, alphaFunctions,allNeuronParameters);

% final spikes matrix
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

% Cell output (L/R for each cell type)
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
    UTIL_plotMatrix(flipud(cellResponse), plotInstructions);
    
    % cell label (allow for spacer rows top and bottom)
    rows=size(cellResponse,1);
    ylim([0 rows+1])
    if rows>2
        set(gca,'YTick', [1 rows-1])
        set(gca,'YTickLabel',{'1', num2str(rows)})
    else
        set(gca,'YTick', 1 )
        set(gca,'YTickLabel',{'1'})
    end
    
        %  CV is computed 5 times (at different time points)
    %  Use the middle one (3) as most typical

    
    disp([cellName ' ' ear '  sumspikes= ' num2str(sum(sum(cellResponse)))])
end

% PSTH analysis of each cell type
figure(11), clf
numTypes=size(units,2);
numFigRows=numTypes;
numFigCols=2;

for unit=1:numel(units)
    spikesMatrixLocations=units(unit).spikesMatrixLocations;
    cellName=units(unit).name;
    ear=units(unit).ear;
    cellResponse= spikesMatrix(spikesMatrixLocations,:);
    PSTHbinWidth=0.0005;
        % PSTH of CN spikes. (bin width is 1/toneFrequency).
        PSTH=UTIL_PSTHmaker(cellResponse, dtSpikes, PSTHbinWidth);
        PSTH=sum(PSTH,1);
        nCNpoints=length(PSTH);
        PSTHtime=PSTHbinWidth:PSTHbinWidth:PSTHbinWidth*nCNpoints;
        subplot(numFigRows,numFigCols, unit), cla
        bar(PSTHtime,PSTH)
        ylabel('spike count')
        xlim([0 max(PSTHtime)])
title([cellName ': ' ear ': N=' num2str(units(unit).quantity)]);
    [cv]= UTIL_CV(cellResponse, dtSpikes, .05);
    cv=cv(2);
    y=ylim;
    x=xlim;
    text ( x(1)+(x(2)-x(1))/1.5, y(1)+(y(2)-y(1))/1.25, ...
        ['CV= ' num2str(cv,'%4.2f')])
    
end



%% neuron
function [spikesMatrix,membranePotential,dendriticCurrent]= neuron ...
    (spikesMatrix,dtSpikes,synapseData,alphaFunctions,allNeuronParameters)

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
% synapseDelay=round(0.002/dtSpikes);
synapseDelay=round(synapseData(:,5)/dtSpikes);

for t=max(synapseDelay)+1:nEpochs
    % establish the state of current input at time t
    % inouts always arrive late
    for synapseNo=1:nSynapses
        currentSourceNo=synapseData(synapseNo,1);
        spikingAction=spikesMatrix(currentSourceNo, t-synapseDelay(synapseNo));
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
    spikesMatrix(nANfibers+1:nCells+nANfibers,t)=spikes';
    
    dGk=-Gk*dtSpikes./tauGk +dGkSpike.*s;
    Gk=Gk+dGk;
    
    % After a spike, the threshold is raised (in some cells)
    %  otherwise it settles to its baseline
    dTh=-(Th-Th0)*dtSpikes./tauTh +s.*ThShift;
    Th=Th+dTh;
    
end         % time
% savedNeuronStatus=[E Gk Th cap tauM Ek dGkSpike tauGk Th0 ThShift tauTh Er Eb];


function allParams=McGparameters
count=0;
%% AN  #1
params.unitTypeNames='AN';
params.nCells=	0;  % must be set after examining the AN input

% AN has no inputs
inputEar=       [        ];    % 0=ipsilateral, -1=contralateral
inputCelltype=  [        ];    % identity of input cell (AN)
nInputs=        [        ];    % number of synapses from this source
currentPerspike=[        ];
dendriteLPfreq= [        ];    % determines synapse alpha function
synapticDelay=  [        ];
params.inputs= [inputEar' inputCelltype' nInputs' currentPerspike' ...
    dendriteLPfreq' synapticDelay'];

params.Cap=0;  
params.tauM=0;  
params.Ek=0;    
params.dGkSpike=    0; 
params.tauGk=       0;
params.Th0=         0; 
params.ThShift=     0;       
params.tauTh=       0; 
params.Er=          0;    
params.Eb=          0;    
count=count+1; allParams{count}=params;

%% CN bushy #2
params.unitTypeNames = 'CN(primary-like)';
params.nCells=	50;              % N neurons per BF

inputEar=       [  0      0];    % 0=ipsilateral, -1=contralateral
inputCelltype=  [  1      3];    % identity of input cell (AN & CNchop)
nInputs=        [  2      10];   % number of synapses from this source
currentPerspike=[ 150e-9 -25e-9]; % CNchopper is inhibitory
dendriteLPfreq= [ 500     50];   % determines synapse alpha function
synapticDelay=  [ .002   .002];
params.inputs= [inputEar' inputCelltype' nInputs' currentPerspike' ...
    dendriteLPfreq' synapticDelay'];

params.Cap=4.55e-9;             % cell capacitance (Farads)
params.tauM=5e-4;               % membrane time constant (s)
params.Ek=-0.01;                % K+ equil. potential (V)
params.dGkSpike=3.64e-5;        % K+ conductance shift after a spike,S
params.tauGk=	0.0012;         % K+ conductance tau (s)
params.Th0=	0.01;               % spiking threshold (V)
params.ThShift=	0.01;           % threshold voltage shift on spike,S.
params.tauTh=	0.015;          % threshold shift time constant
params.Er=-0.06;                % resting potential (V)
params.Eb=0.06;                 % spike height above resting (V)
count=count+1; allParams{count}=params;

%% CN chopper #3
params.unitTypeNames = 'CN(chopT)';
params.nCells=	50;             % N neurons per BF

inputEar=         0      ;    % 0=ipsilateral, -1=contralateral
inputCelltype=    1      ;    % identity of input cell (AN)
nInputs=          5     ;    % number of synapses from this source
currentPerspike= 30e-9   ;
dendriteLPfreq=  50      ;    % determines synapse alpha function
synapticDelay=   .002    ;
params.inputs= [inputEar' inputCelltype' nInputs' currentPerspike' ...
    dendriteLPfreq' synapticDelay'];

params.Cap=1.67e-8;             % cell capacitance (Farads)
params.tauM=0.002;              % membrane time constant (s)
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
params.nCells=	40;               % N neurons per BF

inputEar=       [  0      -1];    % 0=ipsilateral, -1=contralateral
inputCelltype=  [  2       2];    % identity of input cell (CN-PL)
nInputs=        [  1       1];    % number of synapses from this source
currentPerspike=[ 200e-9 200e-9];
dendriteLPfreq= [ 500     500];   % determines synapse alpha function
synapticDelay=  [ .002   .002+ 1/(8*750)]; % BF=
params.inputs= [inputEar' inputCelltype' nInputs' currentPerspike' ...
    dendriteLPfreq' synapticDelay'];

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
params.unitTypeNames = 'IC(chopper)';
params.nCells=	10;           % N neurons per BF

inputEar=         0      ;    % 0=ipsilateral, -1=contralateral
inputCelltype=    4      ;    % identity of input cell (ipsi MSO)
nInputs=          20     ;    % number of synapses from this source
currentPerspike= 50e-9   ;
dendriteLPfreq=  50      ;    % determines synapse alpha function
synapticDelay=   .002    ;
params.inputs= [inputEar' inputCelltype' nInputs' currentPerspike' ...
    dendriteLPfreq' synapticDelay'];

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
params.unitTypeNames = 'IC(chopperDiff)';
params.nCells=	1;                % N neurons per BF

inputEar=       [  0      -1];    % 0=ipsilateral, -1=contralateral
inputCelltype=  [  4       4];    % MSO ipsi excitatory/ contra inhibitory
nInputs=        [  20      20];   % number of synapses from this source
currentPerspike=[ 50e-9 50e-9];
dendriteLPfreq= [ 50     50];     % determines synapse alpha function
synapticDelay=  [ .002   .002];
params.inputs= [inputEar' inputCelltype' nInputs' currentPerspike' ...
    dendriteLPfreq' synapticDelay'];

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
