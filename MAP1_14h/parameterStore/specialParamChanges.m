function paramChanges=specialParamChanges
% specialParamChanges changes parameters after the MAPparams file has been
% read. It is useful when a large number of parameters need to be explored
% while leaving MAPparams* intact.
%
% Parameter changes on the multiThresholdGUI will take priority and these
% should be used for small changes between sessions.
%
% In regular use, this function should be empty!
%
% This function is called from the MAPparams***.m file


paramChanges={ };

