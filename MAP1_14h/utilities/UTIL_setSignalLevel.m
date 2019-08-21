function signal=UTIL_setSignalLevel(signal, dBSPLrms)
% UTIL_setSignalLevel
% output signal is expressed in Pascals with rms=dBSPLrms
rms= 20*log10((mean(signal.^2).^0.5)/20e-6);
gain=10.^((dBSPLrms-rms)/20);
signal=signal*gain;
