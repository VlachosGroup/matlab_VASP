function VASP_Outcritic_to_XSD
%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%
%   Read CONTCAR and Outcritic file.
%   Outcritic is critic2 software output file that does bond critical point
%   analysis
%
%   Input:
%       paths (that has CONTCAR)
%   Output:
%       Creates XSD files in the folder POSCAR/CONTCAR/XDATCAR is in
%
% Script goes through all subfolders (including specified folders) and find
% POSCAR/CONTCAR/XDATCAR and convert.
% For NEB, the script search for POSCAR in folder name 00, and convert.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% path set up
% script find all VASP files - including files within all the subflolders 
input_fldr = 'D:\checking\4-20\CpCpCdM\';
%%% bond critical point property is printed in charge of the an fake atom
%%% and you can choose what properties is to be written:
F_BCP = 3; 
% 1 = Electronic density
% 2 = Laplacian
% 3 = Ellipticity
gas = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
addpath([paths.mfile 'etc_library\grep04apr06\']);

%% Convert
flist = rdir([input_fldr '\**\CONTCAR']);
for i=1:length(flist)
    %%% set up name
    paths.input = flist(i).name;
    slash_index = regexp(paths.input,'\');
    name = [paths.input(1:end-7) paths.input(slash_index(end-1)+1:slash_index(end)-1) '.xsd'];
    %%% Read VASP config
    [mol_data] = VASP_Config_Read(paths.input);
    %%% Read Outcritic
    [BCP] = Outcritic_Read([paths.input(1:end-7) 'Outcritic']);
    %%% remove Pt-Pt bonds
    if gas == 0;
        % find metal atom
        [~, I]=sort(mol_data.positions(:,3));
        metal_element = mol_data.chemical_symbols{I(1)};
        m_indexes = find(strcmp(mol_data.chemical_symbols,metal_element));
        % find highest z position of slab
        [metal_z] = sort(mol_data.positions(m_indexes,3),'descend'); %#ok<FNDSB>
        highest_metal_z = metal_z(1);
        Z_tol = highest_metal_z + 0.15/sqrt(mol_data.cell(3,:)* mol_data.cell(3,:)'); % 0.15 angstrom above highest metal atom
        for j=length(BCP):-1:1
            if BCP(j).positions(3) < Z_tol || BCP(j).positions(3) > 0.8
                BCP(j) = [];
            end
        end
    end
    %%% Write BCP into mol_data
    mol_data.unique_elements{end+1} = 'P';
    mol_data.charge = zeros(size(mol_data.positions,1),1);
    for j=1:length(BCP)
        mol_data.chemical_symbols{end+1} = 'P';
        mol_data.positions(end+1,:) = BCP(j).positions;
        % write BCP property
        switch F_BCP
            case 1
                mol_data.charge(end+1) = BCP(j).ED;
            case 2
                mol_data.charge(end+1) = BCP(j).LAP;
            case 3
                mol_data.charge(end+1) = BCP(j).ellipticity;
        end
    end
    
    %%% Write mol_data
    XSD_Write(name,mol_data)
end


end


    
