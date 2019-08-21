function ave=UTIL_mean(x)
% UTIL_mean computes the mean after omitting any missing data
ave=mean(x(~isnan(x)));
