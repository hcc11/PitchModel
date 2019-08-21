function testPhysiology(BF,paramsName, paramChanges)
% testPhysiology is a portmanteau programs that
%   invokes a number of physiological assessments to test the
%   'spikes' model. Tests invoked are 
%   testOME, testBM testRP2 testSynapse testForwardMasking testPhaseLocking testAN
%Input arguments:
%  BF: single channel model best frequency
%  paramsName: parameter file name containing model parameters.
%   (default='Normal')
%    NB the program assumes that two fiber types are nominated, i.e. two
%    values of ANtauCas are specified.
%  paramChanges: cell array contining list of changes to parameters. These
%   are implemented after reading the parameter file (default='')
%
% e.g.
% testPhysiology(1000,'Normal', {});


restorePath=setMAPpaths;

if nargin<3,  paramChanges=[]; end

if nargin<2, paramsName='Normal'; end

if nargin<1, BF=1000; end

disp('testPhysiology...........computing')
disp('testOME...........computing')
testOME(paramsName,paramChanges)

relativeFrequencies=1; % only BF tones tested
toneDuration=0.5; % long enough to show MOC
allChannelModel=0; % single channel model
disp('testBM...........computing')
testBM (BF, paramsName,relativeFrequencies,'spikes', ...
    paramChanges,allChannelModel, toneDuration)

disp('testRP...........computing')
testRP2(paramsName,paramChanges)

disp('testSynapse...........computing')
testSynapse(BF,paramsName, 'spikes', paramChanges)

disp('testForwardMasking...........computing')
testForwardMasking(BF,paramsName,'spikes', paramChanges)

disp('testPhaseLocking...........computing')
testPhaseLocking(paramsName,paramChanges)

disp('testAN...........computing')
testAN(BF,BF, -10:10:80,paramsName,paramChanges,1);

% put these figures on top
figure(14)
figure(15)

MAPparamsNormal(-1, 48000, 1);

path(restorePath)
