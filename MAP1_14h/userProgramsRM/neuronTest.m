function neuronTest
% Ray's grand attempt to build a brainstem model incorporating any number
% of different cell types with a variety of interconnections.
% This is work in progress! Not documented.

global cellArchitecture cellTypeNo nCells cellRangeEnd params
global allNeuronParameters allAlphaFunctions allInputANMatrices
global dtSpikes nANinputFibers


load spikeSample %ANspikes, dtSpikes
ANspikes=ANoutput;
[nANinputFibers, nEpochs]=size(ANspikes);
binSpikes=[ANspikes; ANspikes];


brainstemCellNos=[30 20 10];
Rptr1=1;
Rptr2=Rptr1+nANinputFibers;
Rptr3=Rptr2+nANinputFibers;

Rptr4=Rptr3+brainstemCellNos(1);
Rptr5=Rptr4+brainstemCellNos(1);

Rptr6=Rptr5+brainstemCellNos(2);
Rptr7=Rptr6+brainstemCellNos(2);

Rptr8=Rptr7+brainstemCellNos(3);
Rptr9=Rptr8+brainstemCellNos(3);

Cptr1=1;
Cptr2=Cptr1+brainstemCellNos(1);
Cptr3=Cptr2+brainstemCellNos(1);

Cptr4=Cptr3+brainstemCellNos(2);
Cptr5=Cptr4+brainstemCellNos(2);

Cptr6=Cptr5+brainstemCellNos(3);
Cptr7=Cptr6+brainstemCellNos(3);

%% CN bushy
nCells=brainstemCellNos(1);
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

% all inputs are AN

ANsynapses=rand(nANinputFibers,nCells)>.95;
connections(1:Rptr2-1, 1:Cptr2-1) = ANsynapses;

ANsynapses=rand(nANinputFibers,nCells)>.95;
connections(Rptr2:Rptr3-1,Cptr2: Cptr3-1) = ANsynapses;

addCellType

%% MSO bushy
nCells=brainstemCellNos(2);
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

% ipsilateral
MSO1synapses=rand(nCells,nCells)>.95;
connections(Rptr3:Rptr4-1, Cptr3:Cptr4-1)= MSO1synapses;

% ipsilateral
MSO1synapses=rand(nCells,nCells)>.95;
connections(Rptr4:Rptr5-1, Cptr3:Cptr4-1)= MSO1synapses;

% contrLateral
MSO1synapses=rand(nCells,nCells)>.95;
connections(Rptr4:Rptr5-1, Cptr4:Cptr5-1)= MSO1synapses;

% contrLateral
MSO1synapses=rand(nCells,nCells)>.95;
connections(Rptr5:Rptr6-1, Cptr4:Cptr5-1)= MSO1synapses;


addCellType

%% IC chopper
nCells=brainstemCellNos(3);

params.nNeuronsPerBF=	10;   % N neurons per BF
params.type = 'IC chopper cell';
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

% ipsilateral
ICsynapses=rand(nCells,nCells)>.95;
connections(Rptr5:Rptr6-1, Cptr3:Cptr4-1)= ICsynapses;

% ipsilateral
ICsynapses=rand(nCells,nCells)>.95;
connections(Rptr6:Rptr7-1, Cptr3:Cptr4-1)= ICsynapses;

addCellType

%% system as a whole
totalCells=size(allNeuronParameters,1);

% binaural
allNeuronParameters=[allNeuronParameters;allNeuronParameters];

% add AN inputs to the bottom of the allSpike array
% no initial activity in the neuron spikes
allSpikes=[false(totalCells,nEpochs); ANspikes] ;
allSpikes=[allSpikes; allSpikes] ;

% cellInputMatrix=false(totalCells,totalCells);

% interconnections for each cell
cellInputMatrix=zeros(totalCells,totalCells);
inputANMatrix=zeros(nANinputFibers,totalCells);
allInputMatrices=[];

cellTypeNo=1;
nCells=cellArchitecture(cellTypeNo).size;

% identify AN input fibers
inputANmatrix=rand(nANinputFibers,nCells)>.95;
allInputMatrices=[allInputMatrices inputANmatrix]; % binaural;

cellTypeNo=2;
nCells=cellArchitecture(cellTypeNo).size;
% identify AN input fibers
inputANmatrix=rand(nANinputFibers,nCells)>.95;
allInputMatrices=[allInputMatrices inputANmatrix]; % binaural;

cellTypeNo=3;
nCells=cellArchitecture(cellTypeNo).size;
% identify AN input fibers
inputANmatrix=rand(nANinputFibers,nCells)>.95;
allInputMatrices=[allInputMatrices inputANmatrix]; % binaural;

inputCellNo=1;
nInputCells=cellArchitecture(inputCellNo).size;
inputRange=cellArchitecture(inputCellNo).cellRange;
inputRange=inputRange(1):inputRange(2);
cellInputMatrix(inputRange,cellRange)=(rand(nInputCells,nCells)>.5);
% identify AN input fibers
inputANmatrix=rand(nANinputFibers,nCells)>.95;
cellInputMatrix=[cellInputMatrix; allInputANMatrices];
allInputMatrices=[allInputMatrices;cellInputMatrix]; % binaural;

% raster display of cell connection matrix
%         subplot(5,2,2+sideCount)
plotInstructions=[];
%         plotInstructions.axes=gca;
plotInstructions.figureNo=1;
plotInstructions.displaydt=dtSpikes;
plotInstructions.title= ['cell connection matrix '];
plotInstructions.plotColor='k';
plotInstructions.rasterDotSize=2;
UTIL_plotMatrix(flipud(allInputMatrices), plotInstructions);

% AN inputs plus Interconnections between cells
% figure(2), clf, imagesc(inputCurrent)

%% run neuronal calculations
[outputSpikes, membranePotential]= ...
    neuron(allSpikes, dtSpikes, allNeuronParameters, ...
    allInputMatrices, allAlphaFunctions);

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
function [cellSpikes, membranePotential, savedNeuronStatus]= ...
    neuron(inputSpikes, dtSpikes, neuronParameters, ...
    inputMatrix, alphaFunctions)

cap=neuronParameters(:,1);
tauM=neuronParameters(:,2);
Ek=neuronParameters(:,3);
b=neuronParameters(:,4);
tauGk=neuronParameters(:,5);
Th0=neuronParameters(:,6);
c=neuronParameters(:,7);
tauTh=neuronParameters(:,8);
Er=neuronParameters(:,9);
Eb= neuronParameters(:,10);

[nFibers, nEpochs]=size(inputSpikes);
[nCells, nParams]=size(neuronParameters);
lengthAlphaFunctions=size(alphaFunctions,2);
inputCurrent=zeros(nCells,nEpochs+lengthAlphaFunctions);
membranePotential=Er(1)*ones(nCells,nEpochs);   % set to resting (not zero)
outputSpikes=false(nCells,nEpochs);

E=zeros(nCells,1);
Gk=zeros(nCells,1);
Th=Th0.*ones(nCells,1);
synapseDelay=round(0.02/dtSpikes);

for t=synapseDelay+1:nEpochs
    inducedCurrent=zeros(nCells,lengthAlphaFunctions);
    
    for i=1:nCells
        % the sum of all inputSpikes at time t featured in the input to the ith
        % cell
        %  selectedSpikes(:,t)= sum(inputSpikes(:,t-inputMatrix(:,i)));
        activeInputs=inputMatrix(:,i);
        availableInputs=1*inputSpikes(:,t-synapseDelay);
        spikesIn= sum(availableInputs & activeInputs);
        
        inducedCurrent(i,:)=spikesIn*alphaFunctions(i,:);
    end
    inputCurrent(:,t:t+lengthAlphaFunctions-1)=...
        inputCurrent(:,t:t+lengthAlphaFunctions-1)+inducedCurrent;
    
    dE = (-E./tauM + ...
        inputCurrent(:,t)./cap + (Gk./cap)...
        .*(Ek-E))*dtSpikes;
    E=E+dE;
    s=E>Th;
    membranePotential(:,t)=E+s.*(Eb-E)+Er;
    spikes=membranePotential(:,t)>-0.01;
    spikes(outputSpikes(spikes,t-1)>0)=0; % disallow spike if already spiking
    % these now act as inputs to other cells
    inputSpikes(1:nCells,t)=spikes;
    
    dGk=-Gk*dtSpikes./tauGk +b.*s;
    Gk=Gk+dGk;
    
    % After a spike, the threshold is raised
    % otherwise it settles to its baseline
    dTh=-(Th-Th0)*dtSpikes./tauTh +s.*c;
    Th=Th+dTh;
end

cellSpikes=inputSpikes(1:nCells,:);
% savedNeuronStatus=[E Gk Th cap tauM Ek b tauGk Th0 c tauTh Er Eb];


%% add cell to system

function addCellType
global dtSpikes nANinputFibers params
global cellArchitecture cellTypeNo nCells cellRangeEnd params
global allNeuronParameters allAlphaFunctions allInputANMatrices

cellTypeNo=cellTypeNo+1;
cellArchitecture(cellTypeNo).size=nCells;

cellRangeStart=cellRangeEnd+1;
cellRangeEnd=cellRangeStart+nCells-1;
cellArchitecture(cellTypeNo).cellRange=[cellRangeStart cellRangeEnd];

cellArchitecture(cellTypeNo).name=params.type;
cellArchitecture(cellTypeNo).params=params;

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

% specify alpha function (effect of a single spike)
dendriteLPfreq= params.dendriteLPfreq;
currentPerSpike=params.currentPerSpike;
spikeToCurrentTau=1/(2*pi*dendriteLPfreq);
% make all alpha functions the same length (5 ms)
t=dtSpikes:dtSpikes:.005;
alphaFunction= (currentPerSpike / ...
    spikeToCurrentTau)*t.*exp(-t / spikeToCurrentTau);

alphaFunctions=repmat(alphaFunction,nCells,1);
allAlphaFunctions=[allAlphaFunctions; alphaFunctions];


