function testPhysiologyProb(BF,paramsName, paramChanges)
% testPhysiologyProb is a portmanteau programs that
%   invokes a number of physiological assessments to test the
%   'probability' model. Tests invoked are 
%   testOME, testBM testRP2 testSynapse testForwardMasking testANprob
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
%  testPhysiologyProb(1000,'Normal', {'DRNLParams.a=20000;'})

dbstop if error

restorePath=setMAPpaths;

if nargin<3,  paramChanges=[]; end

if nargin<2, paramsName='Normal'; end

if nargin<1, BF=1000; end

disp('testPhysiologyProb...........computing')

disp('testOME...........computing')
testOME(paramsName, paramChanges)

relativeFrequencies=1; % only BF tones tested
toneDuration=0.5; % long enough to show MOC
allChannelModel=0; % single channel model
disp('testBM...........computing')
testBM (BF, paramsName,relativeFrequencies,'probability', paramChanges,allChannelModel, toneDuration)

disp('testRP...........computing')
testRP2(paramsName,paramChanges)

disp('testSynapse...........computing')
testSynapse(BF,paramsName, 'probability', paramChanges)

disp('testForwardMasking...........computing')
testForwardMasking(BF,paramsName,'probability', paramChanges)

disp('testANprob...........computing')
testANprob(BF,BF, -10:10:80,paramsName, paramChanges);

figure(4)

MAPparamsNormal(-1, 48000, 1)

path(restorePath)
