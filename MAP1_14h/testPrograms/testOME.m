function testOME(paramsName, paramChanges)
% testOME computes the external resonance and
%  stapes response at a number of frequencies
% It compares the stapes displacement against human in vivo data
%  collected by Huber et al.2001.
% Note that Huber's patients were deaf so no MOC is likely to be active
%  nor will acoustic reflex be active
%
% Input arguments:
%   paramsName: name of file in parameterStore containing model parameters
%   paramchanges: string array of changes to parameters.
%    this can be omitted or '' is an acceptable argument
%
% testOME('Normal','')


restorePath=setMAPpaths;

global OMEoutput  OMEextEarPressure OMEParams

% default arguments
if nargin<2, paramChanges=[]; end
if nargin<1, paramsName='Normal'; end

leveldBSPL=80; 		% dB SPL as used by Huber (may trigger AR)
amp=10^(leveldBSPL/20)*28e-6;

sampleRate=50000;
dt=1/sampleRate;
duration=.05;
time=dt: dt: duration;

        % switch off AR & MOC (Huber's patients were deaf)
        idx=length(paramChanges);
        paramChanges{idx+1}='OMEParams.rateToAttenuationFactorProb=0 ;';
        

%% Comparison data (human)
% These data are taken directly from Huber 2001 (Fig. 4)
HuberFrequencies=[600	  800	 1000	 2000	 3000	4000 6000 8000];
HuberDisplacementAt80dBSPL=[1.5E-9	1.5E-09	1.5E-09	1.0E-09	7.0E-10	...
    3.0E-10	2.0E-10	1.0E-10]; % m;
% HuberVelocityAt80dBSPL= 2*pi*HuberFrequencies.*HuberDisplacementAt80dBSPL;

figure(2), clf, subplot(2,1,2)
set(2,'position',[5   349   268   327])
semilogx(HuberFrequencies, 20*log10(HuberDisplacementAt80dBSPL/1e-10),...
    'ko', 'MarkerFaceColor','k', 'Marker','o', 'markerSize',6)
hold on

% From Geisler (just for a sense of scale)
% GuineaPigData_nm=[
%     100	200;
% 500	100;
% 1000	50;
% 3000	20;
% 5000	5;
% 10000  0.045;
% ];
% semilogx(GuineaPigData_nm(:,1), 20*log10(1e-9*GuineaPigData_nm(:,2)/1e-10))
drawnow

%% Generate test stimulus .................................................................

% independent test using discrete frequencies
frequencies=[200 400 HuberFrequencies 10000];
for pass=1:2
peakResponses=[];
peakTMpressure=[];
    for toneFrequency=frequencies
        inputSignal=amp*sin(2*pi*toneFrequency*time);
        AN_spikesOrProbability='probability';
        idx=length(paramChanges);
        if pass==2
            % use only the first filter on the first pass
            % identify external resonance filters
%             MAPparamsNormal (1000, sampleRate, 0, {})
            externalResonanceFilters=OMEParams.externalResonanceFilters(1,:);
            paramChanges{idx+1}=...
                ['OMEParams.externalResonanceFilters=[' ...
                num2str(externalResonanceFilters) '];'];
        end
        
        % BF is irrelevant
        MAP1_14(inputSignal, sampleRate, -1, ...
            paramsName, AN_spikesOrProbability, paramChanges);
        
        peakDisplacement=max(OMEoutput(floor(end/2):end));
        peakResponses=[peakResponses peakDisplacement];
        
        peakTMpressure=[peakTMpressure max(OMEextEarPressure)];
    end
%% Report
disp('frequency displacement(m)')
% disp(num2str([frequencies' peakResponses']))
fprintf('%6.0f \t%10.3e\n',[frequencies' peakResponses']')

% stapes peak displacement
figure(2), subplot(2,1,2), hold on
if pass==1, color='r';else color='b';end
semilogx(frequencies, 20*log10(peakResponses/1e-10), color, 'linewidth',4)
set(gca,'xScale','log')
% ylim([1e-11 1e-8])
xlim([100 10000])
% ylim([0 35])
title(['stapes at ' num2str(leveldBSPL) ' (NB no MOC or AR)'])
ylabel('disp: dB re 1e-10m')
xlabel('stimulus frequency (Hz)')
set(gcf,'name','OME')

% external ear resonance
figure(2), subplot(2,1,1)
semilogx(frequencies, 20*log10(peakTMpressure/28e-6)-leveldBSPL,...
    'k', 'linewidth',2)
xlim([100 10000]) %, ylim([-10 30])
grid on, hold on
title(['External ear resonances' ])
ylabel('dB')
xlabel('frequency')
set(gcf,'name','OME: external resonances')
end
hold off

figure(2), subplot(2,1,2)
legend({'Huber et al','stapes','Huber fit'},'location','southWest')
legend boxoff

% ---------------------------------------------------------- display parameters
UTIL_showStruct(OMEParams,'OMEParams')
disp(['parameter file was: ' paramsName])
disp([' signal level is ' num2str(leveldBSPL) ' dB SPL'])
fprintf('\n')

path(restorePath);
