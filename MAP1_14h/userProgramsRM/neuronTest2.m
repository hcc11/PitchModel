function neuronTest2
% Ray's grand attempt to build a brainstem model incorporating any number
% of different cell types with a variety of interconnections.
% This is work in progress! Not documented.

global cellArchitecture nCellTypes nCells cellRangeEnd params nEpochs
global allNeuronParameters alphaFunction allInputANMatrices
global dtSpikes nANinputFibers 
global spikes connectionMatrix nTotalCells

load spikeSample %ANspikes, dtSpikes
ANspikes=ANoutput;
[nANinputFibers, nEpochs]=size(ANspikes);
disp(['ANspikes: ' num2str(sum(sum(ANspikes)))]);

alphaFunction=[];
allNeuronParameters=[];

cellRangeEnd=nANinputFibers;
nCellTypes=0;


%% CN bushy
nCells=50;
params.nNeuronsPerBF=	100;   % N neurons per BF
params.type = 'primary-like cell';
params.fibersPerNeuron=3;   % N input fibers
params.dendriteLPfreq=500;  % dendritic filter
params.currentPerSpike=100e-9; % (A) per spike
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

nCellTypes=nCellTypes+1;
cellArchitecture(nCellTypes).size=nCells;

cellRangeStart=cellRangeEnd+1;
cellRangeEnd=cellRangeStart+nCells-1;
cellArchitecture(nCellTypes).cellRange=[cellRangeStart cellRangeEnd];

cellArchitecture(nCellTypes).name=params.type;
cellArchitecture(nCellTypes).params=params;

% [neuronParameters,alphaFunctions]= ...
%     perpareParameters(params, nCells, dtSpikes);
% establish parameters as a row vector
neuronParameters=[
    params.Cap
    params.tauM
    params.Ek
    params.dGkSpike
    params.tauGk
    params.Th0
    params.c
    params.tauTh
    params.Er
    params.Eb
    ];
neuronParameters=repmat(neuronParameters',nCells,1);
allNeuronParameters=[allNeuronParameters; neuronParameters];

cellArchitecture(nCellTypes).inputs= ...
    [1 nANinputFibers];

% specify alpha function for each input)
dendriteLPfreq= params.dendriteLPfreq;
currentPerSpike=params.currentPerSpike;
spikeToCurrentTau=1/(2*pi*dendriteLPfreq);
% make all alpha functions the same length (5 ms)
t=dtSpikes:dtSpikes:.005;
alphaFunction{nCellTypes}= (currentPerSpike / ...
    spikeToCurrentTau)*t.*exp(-t / spikeToCurrentTau);


%% MSO 
nCells=50;
params.nNeuronsPerBF=	100;   % N neurons per BF
params.type = 'primary-like cell';
params.fibersPerNeuron=3;   % N input fibers
params.dendriteLPfreq=500;  % dendritic filter
params.currentPerSpike=100e-9; % (A) per spike
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
nCellTypes=nCellTypes+1;
cellArchitecture(nCellTypes).size=nCells;

cellRangeStart=cellRangeEnd+1;
cellRangeEnd=cellRangeStart+nCells-1;
cellArchitecture(nCellTypes).cellRange=[cellRangeStart cellRangeEnd];

cellArchitecture(nCellTypes).name=params.type;
cellArchitecture(nCellTypes).params=params;

% each column specifies a list of input fibers
% [neuronParameters,alphaFunctions]= ...
%     perpareParameters(params, nCells, dtSpikes);
% establish parameters as a row vector
neuronParameters=[
    params.Cap
    params.tauM
    params.Ek
    params.dGkSpike
    params.tauGk
    params.Th0
    params.c
    params.tauTh
    params.Er
    params.Eb
    ];
neuronParameters=repmat(neuronParameters',nCells,1);
allNeuronParameters=[allNeuronParameters; neuronParameters];

cellArchitecture(nCellTypes).inputs= ...
    [1 nANinputFibers];

% specify alpha function for each input)
dendriteLPfreq= params.dendriteLPfreq;
currentPerSpike=params.currentPerSpike;
spikeToCurrentTau=1/(2*pi*dendriteLPfreq);
% make all alpha functions the same length (5 ms)
t=dtSpikes:dtSpikes:.005;
alphaFunction{nCellTypes}= (currentPerSpike / ...
    spikeToCurrentTau)*t.*exp(-t / spikeToCurrentTau);

%% IC chopper
nCells=30;
params.type = 'chopper cell';
params.nNeuronsPerBF=	10;   % N neurons per BF
params.fibersPerNeuron=10;  % N input fibers
params.dendriteLPfreq=150;   % dendritic filter
params.currentPerSpike=90e-9; % *per spike
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
params.PSTHbinWidth=	1e-4;
nCellTypes=nCellTypes+1;
cellArchitecture(nCellTypes).size=nCells;

cellRangeStart=cellRangeEnd+1;
cellRangeEnd=cellRangeStart+nCells-1;
cellArchitecture(nCellTypes).cellRange=[cellRangeStart cellRangeEnd];

cellArchitecture(nCellTypes).name=params.type;
cellArchitecture(nCellTypes).params=params;

% each column specifies a list of input fibers
% [neuronParameters,alphaFunctions]= ...
%     perpareParameters(params, nCells, dtSpikes);
% establish parameters as a row vector
neuronParameters=[
    params.Cap
    params.tauM
    params.Ek
    params.dGkSpike
    params.tauGk
    params.Th0
    params.c
    params.tauTh
    params.Er
    params.Eb
    ];
neuronParameters=repmat(neuronParameters',nCells,1);
allNeuronParameters=[allNeuronParameters; neuronParameters];

cellArchitecture(nCellTypes).inputs= ...
    [1 nANinputFibers];

% specify alpha function for each input)
dendriteLPfreq= params.dendriteLPfreq;
currentPerSpike=params.currentPerSpike;
spikeToCurrentTau=1/(2*pi*dendriteLPfreq);
% make all alpha functions the same length (5 ms)
t=dtSpikes:dtSpikes:.005;
alphaFunction{nCellTypes}= (currentPerSpike / ...
    spikeToCurrentTau)*t.*exp(-t / spikeToCurrentTau);

%% system as a whole
nCells=size(allNeuronParameters,1);
nInputs=nANinputFibers+nCells;

connectionMatrix=zeros(nANinputFibers+nTotalCells, nANinputFibers+nTotalCells);;
spikes=zeros(nInputs,nEpochs);
spikes(1:nANinputFibers,1:nEpochs)=ANspikes;

for i=1:nCellTypes;
    cellRange= cellArchitecture(i).cellRange;
    cellNosIdx=cellRange(1):cellRange(2);
    nCells= cellRange(2)-cellRange(1)+1;
    inputRange= cellArchitecture(i).inputs;
    inputsIdx=inputRange(1):inputRange(2);
    nInputs=length(inputsIdx);
    connections=rand(nInputs,nCells)>.95;
    connectionMatrix(inputsIdx,cellNosIdx)=connections;
end



% raster display of cell connection matrix
%         subplot(5,2,2+sideCount)
plotInstructions=[];
%         plotInstructions.axes=gca;
plotInstructions.figureNo=2;
plotInstructions.displaydt=dtSpikes;
plotInstructions.title= ' cell connection matrix';
plotInstructions.plotColor='k';
plotInstructions.rasterDotSize=2;
plotInstructions.xLabel='receiving cell number';
plotInstructions.yLabel=' spike source ';
UTIL_plotMatrix(flipud(connectionMatrix>0), plotInstructions);

% raster display of spiking activity
%         subplot(5,2,2+sideCount)
plotInstructions=[];
%         plotInstructions.axes=gca;
plotInstructions.figureNo=4;
plotInstructions.displaydt=dtSpikes;
plotInstructions.title= 'initial spiking activity';
plotInstructions.plotColor='k';
plotInstructions.rasterDotSize=2;
plotInstructions.yLabel=' spike source ';
plotInstructions.xLabel='time';
UTIL_plotMatrix(flipud(spikes>0), plotInstructions);


%% run neuronal calculations
 neuron;

% figure(2), clf, imagesc(membranePotential)
% figure(2), clf, surf(membranePotential)
% view([-34 75])
% xlim([0 2500])

for i=1:length(cellArchitecture)
    cellArchitecture(i)
end

% raster display of CN spikes
%         subplot(5,2,2+sideCount)
plotInstructions=[];
%         plotInstructions.axes=gca;
plotInstructions.figureNo=3;
plotInstructions.displaydt=dtSpikes;
plotInstructions.title= ['all spikes '];
plotInstructions.plotColor='k';
if sum(sum(outputSpikes))<100
    plotInstructions.rasterDotSize=3;
else
    plotInstructions.rasterDotSize=2;
end
UTIL_plotMatrix(flipud(outputSpikes), plotInstructions);


%%
function neuron

global dtSpikes nANinputFibers params nEpochs
global cellArchitecture nCellTypes nCells cellRangeEnd params
global allNeuronParameters alphaFunction allInputANMatrices
global spikes connectionMatrix cellSpikes nTotalCells

cap=allNeuronParameters(:,1);
tauM=allNeuronParameters(:,2);
Ek=allNeuronParameters(:,3);
b=allNeuronParameters(:,4);
tauGk=allNeuronParameters(:,5);
Th0=allNeuronParameters(:,6);
c=allNeuronParameters(:,7);
tauTh=allNeuronParameters(:,8);
Er=allNeuronParameters(:,9);
Eb= allNeuronParameters(:,10);

nTotalCells=size(allNeuronParameters,1);

lengthAlphaFunction=length(alphaFunction{1});
inputCurrent=zeros(nTotalCells, lengthAlphaFunction);
membranePotential=Er(1)*ones(nTotalCells,nEpochs);   % set to resting (not zero)

E=zeros(nTotalCells,1);
Gk=zeros(nTotalCells,1);
Th=Th0.*ones(nTotalCells,1);
synapseDelay=round(0.02/dtSpikes);

lengthFunction=length(alphaFunction{1});
allAlphaFunctions=zeros(nCellTypes,lengthFunction);
for i=1:nCellTypes
    cellRange=cellArchitecture(i).cellRange;
    idx=cellRange(1):cellRange(2);
    nCells=cellRange(2)-cellRange(1)+1;
allAlphaFunctions(idx, :)=...
    repmat(alphaFunction{i},nCells,1);
end


for t=synapseDelay+1:nEpochs
    inducedCurrent=zeros(nTotalCells,lengthAlphaFunction);
    
    for i=1:nTotalCells
        % the sum of all inputSpikes at time t featured in the input to the ith
        % cell
        connections=connectionMatrix(:,i);
        activeInputs=sum(connections.*spikes(:,i));
        
        inducedCurrent(i,:)=activeInputs*allAlphaFunctions(i);
    end
    inputCurrent(:,t:t+lengthAlphaFunction-1)=...
        inputCurrent(:,t:t+lengthAlphaFunction-1)+inducedCurrent;
    
    dE = (-E./tauM + ...
        inputCurrent(:,t)./cap + (Gk./cap)...
        .*(Ek-E))*dtSpikes;
    E=E+dE;
    s=E>Th;
    membranePotential(:,t)=E+s.*(Eb-E)+Er;
    spikes=membranePotential(:,t)>-0.01;
    spikes(outputSpikes(spikes,t-1)>0)=0; % disallow spike if already spiking
    % these now act as inputs to other cells
    cellSpikes(1:nTotalCells,t)=spikes;
    
    dGk=-Gk*dtSpikes./tauGk +b.*s;
    Gk=Gk+dGk;
    
    % After a spike, the threshold is raised
    % otherwise it settles to its baseline
    dTh=-(Th-Th0)*dtSpikes./tauTh +s.*c;
    Th=Th+dTh;
end

cellSpikes=inputSpikes(1:nTotalCells,:);
% savedNeuronStatus=[E Gk Th cap tauM Ek b tauGk Th0 c tauTh Er Eb];


%% add cell to system

function addCellType
global dtSpikes nANinputFibers params nCellTypes
global cellArchitecture nCells cellRangeEnd params
global allNeuronParameters alphaFunction allInputANMatrices


alphaFunctions=repmat(alphaFunction,nCells,1);
alphaFunction=[alphaFunction; alphaFunctions];


