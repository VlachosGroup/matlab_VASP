%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%
%   If you made xsd file with energy written out option, this file will
%   remove those energy from the name
%   Input:
%       input_fldr = path of where xsd files are
%   Output:
%       renamed xsd files
%
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% path set up
% script find all VASP files - including files within all the subflolders 
input_fldr = 'C:\Users\Gu\Documents\Materials Studio Projects\GA+LSR Files\Documents\Group Additivity\2-3-get_group\';
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
newline = char(10);
flist = rdir([input_fldr '\**\*.xsd']);
for i=1:length(flist)
    if length(flist(i).name) > 12 && ~isempty(regexp(flist(i).name(end-11:end-4),'-[0-9]{3,}.[0-9]{3,}'))
        movefile(flist(i).name,[flist(i).name(1:end-12) '.xsd']);
    end
end

