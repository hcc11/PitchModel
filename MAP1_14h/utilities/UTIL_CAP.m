function wholeNerveCAP  = UTIL_CAP...
   (ANresponse, dtspikes, BFlist, plotCAP, upperCutoff, lowerCutoff)
% UTIL_CAPgenerator generates a compound action potential
%   by convolving an impulse response, with the response of the
%   auditory nerve as defined by Mark Chertoff (2004, JASA), .
%
%   impulse response is  -e(-k*time)*SIN(2*PI()*f*time)
%
%    mu(t) = e^-kt * sin(omega*t)
%    omega = 2 * pi * f
%
%
% Robert T. Ferry
% 01st May 2008
%
% Revised Ray Meddis, Feb 2014
%
% input arguments_
%  ANresponse: is a logical matrix (channels x time) of spikes
%  dtSpikes: is the sampling interval (normally this is longer than the
%   original sampling interval used for the input signal to MAP)
%  plotCAP: is an invitation to plot the results of the convolution
%
% output arguments_
% wholeNerveCAP: is the result of convolving ANresponse with the impulse
%  response. The sampling interval is dtSpikes

numChannels=length(BFlist);
[numANfibers nSpikeEpochs]=size(ANresponse);

e                   = exp(1);
k                   = 1000;
impulseDuration     = 0.01;
impulseFrequency    = 750;
impulseTime         = dtspikes:dtspikes:impulseDuration;
impulseResponse     = -e.^(-k*impulseTime).*sin(2*pi*impulseFrequency*impulseTime);
impulseResponse=impulseResponse-mean(impulseResponse);

% WholeNerveCAP
ANoutput = sum(ANresponse, 1);
% figure(5), plot(dtspikes:dtspikes:dtspikes*nSpikeEpochs,sum(ANresponse,1))

convolvedWholeNerveCAP = conv(ANoutput, impulseResponse(1,:));
% truncate
% convolvedWholeNerveCAP=convolvedWholeNerveCAP(1:nSpikeEpochs);

% apply measurement time constant
wholeNerveCAP = UTIL_Butterworth(convolvedWholeNerveCAP, dtspikes, ...
   lowerCutoff, upperCutoff,1);

% or do not do this
% wholeNerveCAP = convolvedWholeNerveCAP;


% Plot output
if (plotCAP == 1)
   figure(9)
   set(gcf,'name',mfilename)
   CAPtime = 1000*(dtspikes:dtspikes:dtspikes*length(wholeNerveCAP));
   subplot(2,1,1)
   plot(CAPtime, wholeNerveCAP)
   title(['AN CAP (whole-nerve)  '   num2str(numChannels)...
      ' channels, ' num2str(numANfibers/numChannels) ' fibers/ch'])
   xlabel('Time (ms)'), ylabel('Amplitude (Pa)')
   xlim([0 20]), ylim([-inf inf])
   
   subplot(2,1,2)
   plot(impulseTime, impulseResponse, 'r')
   title('Impulse response')
   xlabel('Time (s)'), ylabel('Amplitude (Pa)')
   xlim([0 max(impulseTime)]), ylim([-inf inf])
   
end
