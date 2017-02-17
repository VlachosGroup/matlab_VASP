function VASP_to_xyz
%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%
%   Creates  xyz files. Requires rdir and grep functions
%
%   Input:
%       paths (that has CONTCAR POSCAR XDATCAR)
%   Output:
%       Creates XSD files in the folder POSCAR/CONTCAR/XDATCAR is in
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% path set up
% script find all VASP files - including files within all the subflolders 
input_fldr = 'C:\Users\Gu\Desktop\Research\Data\People\Angie\COSMO\';
convert_CONTCAR = 1;
convert_POSCAR = 0;
%%% if turned on, will print energy if OSZICAR is found
% For NEB, image with highest energy will be printed out
options.read_OSZICAR_and_include_energy_in_file_name = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
addpath([paths.mfile 'etc_library\grep04apr06\']);

%% find paths to files
switch convert_CONTCAR; case 1;
    flist = rdir([input_fldr '\**\CONTCAR']);
    
end
switch convert_POSCAR; case 1;
    flist = [flist; rdir([input_fldr '\**\POSCAR'])]; 
end
%% Read and convert
for i=1:length(flist)
    slash_index = regexp(flist(i).name,'\');
    %%% Read OSZICAR & set up name
    name = flist(i).name(slash_index(end-1)+1:slash_index(end)-1);
    if options.read_OSZICAR_and_include_energy_in_file_name && exist([flist(i).name(1:slash_index(end)) 'OSZICAR'],'file')
        [E]=OSZICAR_Read([flist(i).name(1:slash_index(end)) 'OSZICAR']);
        name = [name sprintf('%3.3f', E.total)];
    end
    %%% Read vasp config
    [mol_data] = VASP_Config_Read(flist(i).name);
    %%% make xyz
    paths_output = [flist(i).name(1:slash_index(end)) name '.xyz'];
    % convert relative coordinates to absolute
    positions = (mol_data.cell'*mol_data.positions')';
    XYZ_Write(paths_output, mol_data.chemical_symbols, positions)
end

end


    
