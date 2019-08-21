function UTIL_printTabTable(M, headers, format)
% printTabTable prints a matrix as a table with tabs between values
%  suitable for pasting into Excel/ word documents
% headers is optional
%  headers is a matrix of strings (one string per row)
%   e.g. headers=strvcat('firstname', 'secondname')
% format is optional but can be used only if headers are specified
%  (so use [] for headers if none required)
%
%  UTIL_printTabTable([1 2; 3 4],strvcat('a1','a2'));
%  UTIL_printTabTable([1 2; 3 4],strvcat('a1','a2'),'%6.3f'));
%  UTIL_printTabTable([1 2; 3 4],num2str([1000 2000]),'%6.3f');

if nargin<3
    format='%g';
end

if nargin>1
    [r c]=size(headers);
    for no=1:r
        fprintf('%s\t',headers(no,:))
    end
    fprintf('\n')
end

[r c]=size(M);

for row=1:r
    for col=1:c
        fprintf('%s',num2str(M(row,col),format))
        if col<c
            fprintf('\t')
        end
    end
    fprintf('\n')
end

