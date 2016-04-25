function xyz_to_xsd
%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%
%   Convert  xyz files to POSCAR/CONTCAR.
%
%   Input:
%       paths (that has CONTCAR POSCAR XDATCAR)
%   Output:
%       Creates XSD files in the folder POSCAR/CONTCAR/XDATCAR is in
%
% Script goes through all subfolders (including specified folders) and find
% POSCAR/CONTCAR/XDATCAR and convert.
% For NEB, the script search for POSCAR in folder name 00, and convert.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% path set up
% script find all VASP files - including files within all the subflolders 
input_fldr = 'C:\Users\Gu\Documents\Materials Studio Projects\MuSic Files\Documents\Ethanol\';
% basis vector
cell = [0 8.53305 0;
        7.3898 -4.2665 0;
        0 0 22.861904];
% number of frozen surface layer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);

%% find paths to files
flist = rdir([input_fldr '\**\*.xyz']);
%% Read and convert
for i=1:length(flist)
    %%% Read
    mol_data = XYZ_Read(flist(i).name);
    mol_data.cell = cell;
    mol_data.lattice = 'direct';
    %%% convert basis vector
    mol_data.positions = (cell'\mol_data.positions')';
    % write POSCAR
    paths_output = [flist(i).name(1:end-3) 'xsd'];
    XSD_Write(paths_output,mol_data)
end

end


    
