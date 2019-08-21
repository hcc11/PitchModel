clear all
x=[];
nFibersPerChannel=50;
nANfiberTypes=2;
nBFs=21;
nEars=2;
for a=1:nFibersPerChannel, 
    for b=1: nANfiberTypes, 
        for c=1:nBFs,
            for d=1:nEars,
                x=[x;[d c b a]]; 
            end 
        end 
    end 
end