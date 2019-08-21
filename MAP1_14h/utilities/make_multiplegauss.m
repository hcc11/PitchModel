function [M,T] = make_multiplegauss(SR,Ncomp,fms,dTs,Lms,ft,Lt)

% MAKE_MULTIPLEGAUSS generates a multi-component masker composed of Ncomp
% Gaussian-shaped tones and a single Gaussian target. Signals are generated
% by 'make_singlegauss.m'. 
%
%   Input parameters & required formats:
%         SR    : [scalar] Sampling rate in Hz.
%         Ncomp : [scalar] Number of desired maskers.
%         fms   : [Ncomp x 1 array] center frequencies of the maskers in Hz.
%         dTs    : [Ncomp x 1 array] Time positions of maskers in ms. 
%                  Negative values for forward maskers, postive values for 
%                  backward maskers (target is always centered at t = 0).
%         Lms   : [Ncomp x 1 array] SPLs of each masker (equally effective levels).
%         ft    : [scalar] Target frequency in Hz.
%         Lt    : [scalar] Target SPL in dB.
%   Output parameters:
%         M     : Multi-component masker.
%         T     : Single target.
% 
% Examplar values used in Laback et al. (2011, see top of Fig.2):
%         Ncomp = 4 
%         fms   = [4000 ; 4000 ; 4000 ; 4000]
%         dTs   = [-24 ; -16 ; -8 ; +8] (3 forward & 1 backward maskers)
%         Lms   = [83.7 ; 76.3 ; 66.3 ; 80.7] (mean values across listeners)
%         ft    = 4000
%         Lt    = variable
% 
%   References:
%       B. Laback, P. Balazs, T. Necciari, S. Savel, S. Meunier, S. Ystad, 
%           & R. Kronland-Martinet. "Additivity of nonsimultaneous masking 
%           for short Gaussian-shaped sinusoids", JASA 129, 888-897, 2011.
% 
%       B. Laback, P. Balazs, G. Toupin, T. Necciari, S.Savel, S. Meunier,
%           S. Ystad, & R. Kronland-Martinet. "Additivity of auditory 
%           masking using Gaussian-shaped tones. Proceedings of the 
%           Acoustics'08 international conference, 2008.
% 
%       N. H. van Schijndel, T. Houtgast, & J. M. Festen. "Intensity 
%           discrimination of Gaussian-windowed tones: Indications for the 
%           shape of the auditory frequency-time window", JASA 105, 3425-3435, 1999.

% Arguments check
narginchk(7,7);
if ~isnumeric(SR) || ~isnumeric(Ncomp) || ~isnumeric(fms) || ~isnumeric(dTs)...
        || ~isnumeric(Lms) || ~isnumeric(ft) || ~isnumeric(Lt)
  error('%s: all arguments must be numeric.',upper(callfun));
end;
if length(fms)~=Ncomp || length(dTs)~=Ncomp || length(Lms)~=Ncomp
    error('%s: arguments fms, dTs, and Lms must have the same length as Ncomp.',upper(callfun));
end
if ~isscalar(SR) || ~isscalar(Ncomp) || ~isscalar(ft) || ~isscalar(Lt)
    error('%s: arguments SR, Ncomp, ft, and Lt must be scalars.',upper(callfun));
end

% Total signal duration in s
t = (dTs(1)-9.7/2)*1E-3:1/SR:(dTs(end)+9.7/2)*1E-3;
dTs = dTs*1E-3;% convert to seconds

% Initialize parameters
gamma = 600;
Ams = 10.^(Lms./20);
At = 10^(Lt/20);
M = zeros(Ncomp,length(t));

% Compute maskers
for k=1:Ncomp
    M(k,:) = Ams(k)*exp(-pi*(gamma*(t-dTs(k))).^2).*sin(2*pi*(t-dTs(k))*fms(k)+(pi/4));
end
M = sum(M);
% Compute target
T = At*exp(-pi*(gamma*t).^2).*sin(2*pi*t*ft+(pi/4));


%% [UNCOMMENT IF NEEDED] Visual & auditory checks 
% % Time and frequency plots
% figure
% subplot(2,1,1)
% plot(t,M,t,T,'r')
% xlabel('Time (sec)'), ylabel('Amplitude'), legend('Maskers','Target')
% title('Time domain')
% subplot(2,1,2)
% plot(linspace(0,SR,length(t)),abs(fft(M))), hold on
% plot(linspace(0,SR,length(t)),abs(fft(T)),'r'), hold off
% xlabel('Frequency (Hz)'), ylabel('Modulus'), legend('Maskers','Target')
% title('Frequency domain')
% % Play signal
% soundsc(M+T,SR)

% eof