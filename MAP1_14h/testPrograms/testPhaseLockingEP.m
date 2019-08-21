function testPhaseLockingEP(paramsName, paramChanges)
% testPhaseLocking estimates vector strenght at a range of frequencies
%   and a range of levels
%   The results are compared with Johnson 1980.
%
% Input arguments:
%  paramsName: parameter file name containing model parameters.
%   (default='Normal')
%    NB the program assumes that two fiber types are nominated, i.e. two
%    values of ANtauCas are specified.
%  paramChanges: cell array contining list of changes to parameters. These
%   are implemented after reading the parameter file (default='')
%
% testPhaseLocking('Normal', {})


restorePath=setMAPpaths;

if nargin<2
   paramChanges=[];
end

if nargin<1
   paramsName='Normal';
end

testFrequencies=[250 500 1000 2000 4000 8000];
levels=0:10:100;
levels=80;

figure(14), clf
set(gcf,'position', [980    36   383   321])
set(gcf,'name', 'phase locking')

targetFrequencies=[250 500 1000 2000 4000 8000];
EPs=0.1:-0.02:.02;
allStrengths=zeros(length(testFrequencies), length(EPs));
peakVectorStrength=zeros(1,length(EPs));

targetFrequencyCount=0;
for targetFrequency=targetFrequencies
EPcount=0;
   targetFrequencyCount=targetFrequencyCount+1;
   for EP=EPs;
      %single test
      EPcount=EPcount+1;
      paramChanges={['IHC_cilia_RPParams.Et='	num2str(EP) ';']};
      vectorStrength=...
         testAN(targetFrequency,targetFrequency, levels,...
         paramsName, paramChanges);
      allStrengths(EPcount,targetFrequencyCount)=vectorStrength';
   end
end
%% plot results
figure(14)
% subplot(2,1,2)
plot(testFrequencies,allStrengths', '+')
xlabel('frequency')
ylabel('vector strength')
legend (num2str(EPs'),'location','eastOutside')
x=1;

% peakVectorStrength(EPcount)=max(vectorStrength);
% subplot(2,1,1)
% plot(EPs,peakVectorStrength)
% grid on
% title ('peak vector strength')
% xlabel('EP')
% ylim([0 1])
% ylabel('vector strength')


