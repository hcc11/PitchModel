function [pos neg allXcross sig]=UTIL_findZeroCrossings(x)
% generates a list of times when the signal, x,
%  goes positive (pos)
%  goes negative (neg)
%
% NB successive values of zero are never treated as zero crossings
% this might occasionally be a problem yielding an unequal number of pos
% and neg crossings.

xsign=sign(x);
xdiffs= diff(xsign);
pos= find(xdiffs>0);
neg= find(xdiffs<0);
allXcross=[pos neg];
allXcross=sort(allXcross);
intervals=[diff(allXcross) 0];

timeStamps=allXcross+round(intervals/2);
peaks=x(timeStamps);
% save only positive peaks
% idx= find(peaks>0);
% peaks=peaks(idx);
% timeStamps=timeStamps(idx);
sig=zeros(size(x));
sig(timeStamps)=peaks;
