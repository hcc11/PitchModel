restorePath=setMAPpaths;

testForwardMasking(1000,'Normal','probability');
testSynapse(1000,'Normal','probability',{}, 1)
testANprob
MAPparamsNormal(-1, 48000, 1);
disp('program:testprograms\pTest')

path(restorePath)