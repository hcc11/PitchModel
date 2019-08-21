function g = make_singlegauss(SR,fo,L)

% MAKE_SINGLEGAUSS generates a Gaussian-shaped tone according to
% s(t) = A*sin(2*pi*fo*(t-dT)+pi/4)*exp(-pi*(gamma*t)^2) where:
%       A     : Amplitude required to achieve a SPL of L dB
%       fo    : centre frequency of the tone
%       gamma : shape factor of the Gaussian window (fixed to 600)
%       pi/4  : allows to maintain the signal energy constant whatever fo
% 
% Note that the Gaussian is truncated in the time domain using a 9.6-ms
% Tukey window as in Depalle & Hélie (1997).
%
%   Input parameters:
%         SR  : Sampling rate in Hz.
%         fo  : center frequency in Hz.
%         L   : SPL of the signal.
%   Output parameters:
%         g   : Gaussian-shaped tone
% 
%   References:
%       P. Depalle & T. Hélie. "Extraction of spectral peak parameters 
%           using a short-time Fourier transform modeling and no sidelobe
%           windows", Proceedings of the IEEE Workshop on Applications of 
%           Signal Processing to Audio and Acoustics (WASPAA'97), 1997.
% 
%       T. Necciari. "Auditory time-frequency masking: Psychoacoustical 
%           measures and application to the analysis-synthesis of sound
%           signals", PhD Thesis, University of Provence Aix-Marseille I, 2010.
% 
%       N. H. van Schijndel, T. Houtgast, & J. M. Festen. "Intensity 
%           discrimination of Gaussian-windowed tones: Indications for the 
%           shape of the auditory frequency-time window", JASA 105, 3425-3435, 1999.

% Arguments check
narginchk(3,3);
if ~isnumeric(SR) || ~isnumeric(fo) || ~isnumeric(L)
  error('%s: all arguments must be numeric.',upper(callfun));
end;

% Initialize parameters
gamma = 600;
A = 10^(L/20);
N = round(9.7E-3*SR);
t = (-N/2:(N/2-1))/SR; % Time vector

% Compute signal
g = A*exp(-pi*(gamma*t).^2).*sin(2*pi*t*fo+(pi/4));

% Truncate signal in time
win = tukeywin(N,.1);
g = g.*win';

%% [UNCOMMENT IF NEEDED] Visual & auditory checks 
% % Time and frequency plots
% figure
% subplot(2,1,1)
% plot(t,g),xlabel('Time (sec)'), ylabel('Amplitude')
% title('Gaussian-shaped tone: Time domain')
% subplot(2,1,2)
% plot(linspace(0,SR,N),abs(fft(g))),xlabel('Frequency (Hz)'), ylabel('Modulus')
% title('Gaussian-shaped tone: Frequency domain')
% % Play signal
% soundsc(g,SR)

% eof