function quickPlot(x,y, labelX,labelY,markers)

if nargin<5,     markers='o-'; end
if nargin<4,      labelY=''; end
if nargin<3,      labelX=''; end


figure(66), clf

plot(x,y,markers)
xlabel(labelX,'fontSize',20)
ylabel(labelY,'fontSize',20)

