function UTIL_plotMatrix(toPlot, method)
% UTIL_plotMatrix general purpose plotting utility for plotting the results
%  of the MAP auditory model.
% All plots are placed in subplots of a figure (default figure 1).
%
% Input arguments:
% 	'toPlot' is matrix (either numeric or logical)
% 	'method' is a structure containing plot instructions
%
% mandatory parameters:
% 	method.displaydt		xValues spacing between data points
%   method.yValues          yaxis labels mandatory only for 3D plots
%
% optional
% 	method.figureNo         default figure(1)
% 	method.numPlots         number of subPlots in the figure (default=1)
% 	method.subPlotNo        number of this plot (default=1)
% 	method.zValuesRange     [min max] value pair to define yaxis limits
%   method.zValuesRange     [min max] CLIMS for 3-D plot
% 	method.yLabel           (string) y-axis label
%   method.minyMaxy         y-axis limits
% 	method.xLabel           (string) x-axis label
% 	method.title  		    (string) subplot title
%   method.bar    		    =1,  to force bar histogram (single channel only)
%   method.view             3D plot 'view' settings e.g. [-6 40]
%   method.axes             (handle) where to plot (overules all others)
%   method.maxPixels        maximum number of pixels (used to speed plotting)
%   method.blackOnWhite     =1; inverts display for 2D plots
%   method.forceLog         positive values are put on log z-scale
%   method.rasterDotSize    min value is 1
%   method.defaultFontSize  deafult= 12
%   method.timeStart        default= dt
%   method.defaultTextColor default ='k'
%   method.defaultAxesColor default ='k'
%   method.nCols            default = 1 (layout for subplots)
%   method.nRows            default=method.numPlots (layout for subplots
%   method.segmentNumber    plot only this segment while 'hold on'
%   method.holdOn           do not clear figure before plotting
%   method.plotColor        colour of single vector plot
%
% e.g.
%   UTIL_plotMatrix(toPlot, method)

dt=method.displaydt;
[r cols]=size(toPlot);
if cols==1
    % toPlot should be a wide matrix or a long vector
    toPlot=toPlot';
end

%% defaults

if ~isfield(method,'numPlots') || isempty(method.numPlots)
    method.numPlots =1;
    method.subPlotNo =1;
end

if ~isfield(method,'figureNo') || isempty(method.figureNo)
    method.figureNo=99;
end

% if ~isfield(method,'zValuesRange') || isempty(method.zValuesRange)
%     method.zValuesRange=[-inf inf];
% end

if ~isfield( method,'blackOnWhite') || isempty(method.blackOnWhite)
    method.blackOnWhite=0;
end
if ~isfield(method,'timeStart')|| isempty(method.timeStart)
    method.timeStart=dt;
end
if ~isfield(method,'objectDuration') || isempty(method.objectDuration)
    [nRows nCols]=size(toPlot); method.objectDuration=dt*nCols;
end
if ~isfield(method,'defaultFontSize') || isempty(method.defaultFontSize)
    method.defaultFontSize=12;
end
if ~isfield(method,'defaultTextColor') || isempty(method.defaultTextColor)
    method.defaultTextColor='k';
    defaultTextColor=method.defaultTextColor;
else
    defaultTextColor='k';
end
if ~isfield( method,'defaultAxesColor') || isempty(method.defaultAxesColor)
    method.defaultAxesColor=defaultTextColor;
end
defaultAxesColor=method.defaultAxesColor;

% arrangement of figure plots in rows and columns
if ~isfield(method,'nCols') || isempty(method.nRows)
    method.nCols=1;
end

if  ~isfield(method,'nRows') || isempty(method.nRows)
    method.nRows= method.numPlots;
end

if ~isfield(method,'rasterDotSize') || isempty(method.rasterDotSize)
    rasterDotSize=1;
else
    rasterDotSize=method.rasterDotSize;
end

if ~isfield(method,'holdOn') || isempty(method.holdOn)
    method.holdOn=0;
end

if ~isfield(method,'plotColor') || isempty(method.plotColor)
    method.plotColor='k';
end

if ~isfield(method,'plotDivider') || isempty(method.plotDivider)
    method.plotDivider=0;
end

if ~isfield(method,'yLabel') || isempty(method.yLabel)
    method.yLabel='';
end

%% begin plotting
% user can specify either an independent axis
%   or a subplot of the current figure (method.figureNo)
%   if both are specified, 'axes' takes priority
if isfield(method,'axes') && ~isempty(method.axes)
    % user defines where to plot it
    axes(method.axes);
    method.numPlots =1;
    method.subPlotNo =1;
    cla
else
figure(method.figureNo)
    % now using a regular figure
    if method.subPlotNo>method.numPlots;
        error('UTIL_plotMatrix: not enough subplots allocated in figure 1.  Check method.numPlots')
    end
    % choose subplot
    subplot(method.nRows,method.nCols,method.subPlotNo),  
    if ~ method.holdOn
        cla
    end
    
    if isfield(method,'segmentNumber') && ~isempty(method.segmentNumber)...
            && method.segmentNumber>1
        % in multi-segment mode do not clear the image
        %  from the previous segment
        hold on
    elseif ~method.holdOn
        % otherwise a fresh image will be plotted
        hold off
        cla
    else
        hold on
    end
end

% xValues applies throughout the funtion
% yValues is normally a vector specifying channel BF
%  this need not be the same as the height of the toPlot matrix
%  because one channel may be represented many times
[numPlotRows numXvalues]=size(toPlot);
xValues=method.timeStart:dt:method.timeStart+dt*(numXvalues-1);

if isfield(method,'yValues') && ~isempty(method.yValues)
    yValues=method.yValues;
else
    % default yValues 1:N
    yValues=1:numPlotRows;
end

% expand yValues to equal height of toPlot matrix
x=[];
for i= round(numPlotRows/length(yValues))
    x=[x yValues];
end
yValues=x;
numYvalues=length(yValues);


% Now start the plot.
%  3D plotting for 4 or more channels
%  otherwise special cases for fewer channels

if ~islogical(toPlot)
    % continuous variables
    switch numYvalues
        case 1                          % single vector (black)
            if isfield(method,'bar') && ~isempty(method.bar)
                % histogram
                bar(xValues, toPlot,method.plotColor)
                method.bar=[]; % avoid carry over between modules
            else
                % waveform
                plot(xValues, toPlot,method.plotColor)
            end
            xlim([0 method.objectDuration])
            if isfield(method,'zValuesRange') ...
                    && ~isempty(method.zValuesRange)
                ylim(method.zValuesRange)
                method.zValuesRange=[]; % avoid carry over between modules
            end
            if isfield(method,'yLabel') && ~isempty(method.yLabel)
                ylabel(method.yLabel, 'color', defaultTextColor)
                method.yLabel=[]; % avoid carry over between modules
            end
            
        case 2                          % 2 x N vector (black and red)
            plot(xValues, toPlot(1,:),'k'), % hold on
            plot(xValues, toPlot(2,:),'r'), % hold off
            xlim([0 method.objectDuration])
            if isfield(method,'zValuesRange') ...
                    && ~isempty(method.zValuesRange)
                ylim(method.zValuesRange)
                method.zValuesRange=[]; % avoid carry over between modules
            end
            if isfield(method,'yLabel')&& ~isempty(method.yLabel)
                ylabel(method.yLabel, 'color', defaultTextColor)
                method.yLabel=[]; % avoid carry over between modules
            end
            
        case 3                       % 3 x N vector (black red and green)
            % this is used for 1 channel DRNL output
            plot(xValues, toPlot(1,:),'k'), hold on
            plot(xValues, toPlot(2,:),'r'),  hold on
            plot(xValues, toPlot(3,:),'g'), hold off
            xlim([0 method.objectDuration])
            if isfield(method,'zValuesRange') ...
                    && ~isempty(method.zValuesRange)
                ylim(method.zValuesRange)
            end
            if isfield(method,'yLabel') &&  ~isempty(method.yLabel)
                ylabel(method.yLabel, 'color', defaultTextColor)
            end
            
        otherwise                       % >3 channels: surface plot
            
            % invert data for black on white matrix plotting
            if  method.blackOnWhite
                toPlot=-toPlot;
            end
            
            % matrix (analogue) plot
            if isfield(method,'forceLog') && ~isempty(method.forceLog)
                % positive values are put on log z-scale
                toPlot=toPlot+min(min(toPlot))+1;
                toPlot=log(toPlot);
                if isfield(method,'title')
                    method.title=[method.title '  (log scale)'];
                else
                    method.title= '(log scale)';
                end
            end
            
            %  zValuesRange scales color map
            if isfield(method,'zValuesRange') ...
                    && ~isempty(method.zValuesRange)
                clims=(method.zValuesRange);
                
                %NB assumes equally spaced y-values
                imagesc(xValues, 1:numPlotRows, toPlot, clims), axis xy;
            else
                % automatically scaled
                %NB assumes equally spaced y-values

%                 % special smoothing for DRNL
%                   appears to be acausal - remove eventually
%                 x=toPlot';
%                 [a b]=size(x);
%                 x=reshape(x, 1, a*b);
%                 x=UTIL_Butterworth(x, method.displaydt, 1, 25, 1);
%                 x=reshape(x, a,b);
%                 toPlot=x';
                

                imagesc(xValues, 1:numPlotRows, toPlot), axis xy;
                
                if ~isfield(method,'zValuesRange')...
                        || isempty(method.zValuesRange)
                    method.zValuesRange=[-inf inf];
                end
                
                if method.blackOnWhite
                    % NB plotted values have negative sign for black on white
                    caxis([-method.zValuesRange(2) -method.zValuesRange(1)])
                else
                    caxis(method.zValuesRange)
                end
            end
            
            % xaxis
            % NB segmentation may shorten signal duration
            [r c]=size(toPlot);
            imageDuration=c*method.displaydt;
            xlim([0 imageDuration])
            
            n=length(yValues);
            minY=min(yValues);
            maxY=max(yValues);
            yTickValues=1:n:numPlotRows;
            yTickLabels(yTickValues>0)=minY;
            yTickValues=[yTickValues numPlotRows];
            yTickLabels=[yTickLabels maxY];
            yTickLabels=num2str(yTickLabels');
            set(gca,'ytick',yTickValues)
            set(gca,'yticklabel',yTickLabels)
            
            set(gca, 'xcolor', defaultAxesColor)
            set(gca, 'ycolor', defaultAxesColor)
            
    end
    
else	% is logical
%     % avoid too many rasters
%         [a b]=size(toPlot);
%         if a>200
%         divider=round(a/200);
%         idx=1:divider:a;
%         toPlot=toPlot(idx,:);
%         [numPlotRows b]=size(toPlot);
%         method.yLabel=['( 200 only sampled ) ' method.yLabel];
%     end
    
    % logical implies spike array. Use raster plot
    [y,x]=find(toPlot);	%locate all spikes: y is fiber number ie row
    x=x*dt+method.timeStart;   % x is time
    plot(x,y, 'o', 'MarkerSize', rasterDotSize, 'color', method.plotColor)
    if numYvalues>1
        set(gca,'yScale','linear')
        set(gca,'ytick', [1 numPlotRows],'FontSize', method.defaultFontSize)
        % show lowest and highest BF value only
        set(gca,'ytickLabel', [min(yValues) max(yValues) ],...
            'FontSize', method.defaultFontSize)
        if method.plotDivider
            % or use labels to identify fiber type
            set(gca,'ytickLabel', {'LSR', 'HSR'},...
                'FontSize', method.defaultFontSize)
        end
    end
    if numPlotRows>1
        ylim([0 numPlotRows+1])
    end
    ylabel ('fiber')
    xlim([0 method.objectDuration])
    if isfield(method,'yLabel') && ~isempty(method.yLabel)
        ylabel(method.yLabel,...
            'FontSize', method.defaultFontSize, 'color', defaultTextColor)
    else
        ylabel('unit',...
            'FontSize', method.defaultFontSize, 'color', defaultTextColor)
    end
end


% add title
if isfield(method,'title') && ~isempty(method.title)
    title(method.title, 'FontSize', method.defaultFontSize, 'color', defaultTextColor)
end

% label axes
if ~isfield(method,'axes') || isempty(method.axes)
    % annotate the x-axis only if it is the last plot on a figure created by this utility
    set(gca,'xtick',[],'FontSize', method.defaultFontSize)
    if method.subPlotNo==method.numPlots
        if isfield(method,'xLabel') && ~isempty(method.xLabel)
            %               set(gca,'ActivePositionProperty','outerposition')
            %  xlabel(method.xLabel)
            xlabel(method.xLabel, 'FontSize', method.defaultFontSize, 'color', defaultTextColor)
        end
        set(gca,'xtickmode','auto') % add timescale to the lowest graph
    end
end

% add user labels to the y-axis if requested
if isfield(method,'yLabel') && ~isempty(method.yLabel)
    ylabel(method.yLabel, 'color', defaultTextColor)
end

% define color
if method.blackOnWhite, 	colormap bone, else 	colormap jet
end

% drawnow
