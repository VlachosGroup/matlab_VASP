function VASP_to_XSD_XTD
%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%
%   Creates  XSD files. Requires rdir and grep functions
%
%   Input:
%       paths (that has CONTCAR POSCAR XDATCAR)
%   Output:
%       Creates XSD files
%
%   TODO: NEB output
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% path set up
% script find all VASP files - including files within all the subflolders 
input_fldr = 'C:\Users\Gu\Desktop\Checking\3-16\H\';
convert_CONTCAR = 0;
convert_XDATCAR = 0;
convert_POSCAR = 1;
convert_NEB = 0;
%%% if turned on, will print energy if OSZICAR is found
options.read_OSZICAR_and_include_energy_in_file_name = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
addpath([paths.mfile 'etc_library\grep04apr06\']);

%% Convert
%%% CONTCAR first
if convert_CONTCAR
    flist = rdir([input_fldr '\**\CONTCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        VASPoutput_to_XSD_XTD(paths,options);      
    end
end

if convert_POSCAR
    flist = rdir([input_fldr '\**\POSCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        VASPoutput_to_XSD_XTD(paths,options);      
    end
end

if convert_XDATCAR
    flist = rdir([input_fldr '\**\XDATCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        VASPoutput_to_XSD_XTD(paths,options);      
    end
end

if convert_NEB
    flist = rdir([input_fldr '\**\00\POSCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        slash_index = regexp(paths.input,'\');
        paths.input = paths.input(1:slash_index(end-1));
        VASP_NEBoutput_to_XTD(paths,options);      
    end
end


end


    
