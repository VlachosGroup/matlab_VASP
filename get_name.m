%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%
%   script find all xsd files in input_fldr including files within all the subflolders 
%   Input:
%       input_fldr = path of where xsd files are
%   Output:
%       record and prints name of xsd files
%
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% path set up
input_fldr = 'C:\Users\Gu\Documents\Materials Studio Projects\GA+LSR Files\Documents\Group Additivity\2-3-get_group\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
newline = char(10);
flist = rdir([input_fldr '\**\*.xsd']);
name = cell(1,length(flist));
for i=1:length(flist)
    slash_index = regexp(flist(i).name,'\');
    name{i} = flist(i).name(slash_index(end)+1:end-4);
    fprintf(1,'%s\n',name{i});
end