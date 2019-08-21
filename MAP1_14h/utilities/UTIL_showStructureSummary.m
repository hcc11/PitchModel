function UTIL_showStructureSummary(structure,name,maxNoArrayValues,fileID)
% showStructureSummary prints out the values of a single structure
% The header is the structure name and each row is a field
% e.g. showStructureSummary(params,'params')
% This not the same as 'UTIL_showstruct'


if nargin<4
    fileID=1; % command window
end

if nargin<3
	maxNoArrayValues=20;
end

fprintf(fileID, '\n%s:', name);

fields=fieldnames(eval('structure'));
% for each field in the structure
for i=1:length(fields)
	y=eval([ 'structure.' fields{i}]);
	if isstr(y),
		% strings
		fprintf(fileID,'\n%s=\t''%s''',  fields{i},y);
	elseif isnumeric(y)
		% arrays
		if length(y)>1
			% vectors
			[r c]=size(y);
			if r>c, y=y'; end

			[r c]=size(y);
			if r>1
				%   fprintf(fileID,'\n%s.%s=\t%g x %g matrix',name, fields{i}, r, c)
				fprintf(fileID,'\n%s=\t%g x %g matrix',fields{i}, r, c);

			elseif c<maxNoArrayValues
				% fprintf(fileID,'\n%s=\t[%s]',  fields{i},num2str(y))
				fprintf(fileID,'\n%s=',  fields{i});
				fprintf(fileID,'\t%g',y);

			else
				fprintf(fileID,'\n%s=\t %g...   [%g element array]', ...
                    fields{i}, y(1),c);
			end
		else
			% single valued arrays
			% fprintf(fileID,'\n%s.%s=\t%s;', name, fields{i},num2str(y))
			fprintf(fileID,'\n%s=\t%s', fields{i},num2str(y));
		end
	elseif iscell(y)
		fprintf(fileID,'\n%s=\t cell array', fields{i});

	elseif isstruct(y)
		fprintf(fileID,'\n%s=\t structure', fields{i});
	end,

end,
fprintf(fileID,'\n');

