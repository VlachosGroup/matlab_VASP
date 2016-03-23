function xyz_to_VASP
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
input_fldr = 'C:\Users\Gu\Desktop\Checking\3-3\out_stableC-OH\';
flname = 'testPOSCAR';
% basis vector
cell = [11.2 0 0;
        5.6 9.699484522385699 0;
        0 0 22.861904265976325];
% number of frozen surface layer
% nfreeze = 'all_surf'; % uncomment this line to freeze all surface atoms
nfreeze = 2;
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
    slash_index = regexp(flist(i).name,'\');
    %%% setup freeze
    mol_data.freeze = zeros(size(mol_data.positions,1),1);
    if strcmp(nfreeze,'all_surf')
        % find the bottom most element and freeze that element
        ZCoord = unique(mol_data.positions(:,3));
        Bottomatoms = find(mol_data.positions(:,3) == ZCoord(1));
        Surf_atom = char(mol_data.chemical_symbols(Bottomatoms(1)));
        fixedatoms = find(strcmp(mol_data.chemical_symbols,Surf_atom)==1)';
        for j=1:size(mol_data.positions,1)
            mol_data.freeze(fixedatoms) = 1;
        end
    elseif nfreeze == 0
        mol_data.freeze = zeros(size(mol_data.positions,1),1);
    else
        Tol = 1e-13;
        ZCoord = unique(Tol*round(1/Tol*mol_data.positions(:,3)));
        % Returns unique rows of Z coordinate with degits upto order of tolerance
        fixedatoms = any(abs(repmat(mol_data.positions(:,3),1,nfreeze)-repmat(ZCoord(1:nfreeze).',size(mol_data.positions,1),1)) < 2*Tol,2);
        for j=1:size(mol_data.positions,1)
            mol_data.freeze(fixedatoms) = 1;
        end
    end
    % write POSCAR
    paths_output = [flist(i).name(1:slash_index(end)) flname];
    POSCAR_Write(paths_output,mol_data)
end

end


    
