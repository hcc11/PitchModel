function phaseshift = phaseextract(inputsignal, outputsignal, sfreq, inputfrequency)

%phaseshift in radians
% sfreq = 44100;
% time = [0:1/sfreq:1];
% inputfrequency = 1000;
% 
% inputsignal = sin(inputfrequency*2*pi.*time);
% outputsignal = sin(inputfrequency*2*pi.*time+pi);

%find local maxima as a (towards negative) signum change in the first derivative
inputmaxima = find(diff(sign(diff(inputsignal))) == -2)+1;
outputmaxima = find(diff(sign(diff(outputsignal))) == -2)+1;

%cut index vectors in order to ensure equal length
inputmaxima = inputmaxima(1:min([length(inputmaxima) length(outputmaxima)]));
outputmaxima = outputmaxima(1:min([length(inputmaxima) length(outputmaxima)]));


%calculate phaseshift as average difference between these maxima
phaseshift_in_samples = inputmaxima - outputmaxima;
phaseshift = mean(phaseshift_in_samples)/sfreq*inputfrequency*2*pi;

%in very rare cases the two adjacent sample values are numerically
%identical, which could cause a phasejump.