function read_Eng
%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%
%   find all OSZICAR and print the energy of last iteration.
%   Print the name of folder as well
%   this script finds all OSZICAR within subfolder as well
%
%   Input:
%       input_fldr = path of where OSZICARs are
%   Output:
%       print name of the folder and energy of the last iteration
%
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
input_fldr = 'C:\Users\Gu\Desktop\Research\checking\1-4';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% automatically add \ to input_fldr if missing
if input_fldr(end) ~= '\'; input_fldr(end+1) = '\'; end
%%% Add the location of the matlab script as path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\grep04apr06\']); % need this for OSZICAR
%%% find all OSZICAR
flist = rdir([input_fldr '\**\OSZICAR']);
%%% Read
for i=1:length(flist)
    path= flist(i).name;
    [E] = OSZICAR_Read(path);
    slash_index = regexp(path,'\');
    name = path(slash_index(end-1)+1:slash_index(end)-1);
    fprintf(1,'%s\t%3.5f\n',name,E.total);
end

end
