%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%
%   change the position of adsorbates from hcp to fcc and vice versa, by
%   multiplying coordinates of the first layer and the adsorbate by -1.
%
%   Input:
%       input_fldr = path of where xsd files are
%       metal = name of the metal
%       dirname = name of the folder that you would like the switched file
%           to go to
%       adjust = [x.xx,x.xx,x.xx] vector that you can add to adjust the
%           position of adsorbate and first layer.
%   Output:
%       new xsd files in dirname folder with hcp and fcc switched
%
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
input_fldr = 'C:\Users\Gu\Desktop\Checking\2-7\switch\';
metal = 'Pt';
dirname = 'switched';
adjust = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
if input_fldr(end) ~= '\'; input_fldr(end+1) = '\'; end
FileList = dir([input_fldr '*.xsd']);
mkdir([input_fldr dirname]);
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
addpath([paths.mfile 'etc_library\grep04apr06\']);
for i = 1:length(FileList);
    %% Loading
    flname = FileList(i).name;
    XSDFileName = [input_fldr flname];
    [mol_data] = XSD_Read_grep(XSDFileName);
    
    %% Moving molecule and the first layer
    
    %%identifying the first layer%%
    N = 0;
    for j = 1:size(mol_data.positions,1)
        if strcmp(metal,mol_data.chemical_symbols{j}) %identify Pt
            if abs(mol_data.positions(j,3)-0.254) < 0.04
                N = N+1;
                PtN(N) = j; %#ok<SAGROW>
            end
        end
    end
    % PtN contains the index of first layer Pt atoms in AtomPos.
    
    % non Pt cases
    for j = 1:size(mol_data.positions,1)
        if ~strcmp('Pt',mol_data.chemical_symbols{j})
            mol_data.positions(j,1) = 1 - mol_data.positions(j,1) - adjust;
            mol_data.positions(j,2) = 1 - mol_data.positions(j,2) - adjust;
            if mol_data.positions(j,1) < 0
                mol_data.positions(j,1) = mol_data.positions(j,1) +1;
            end
            if mol_data.positions(j,2) < 0
                mol_data.positions(j,2) = mol_data.positions(j,2) +1;
            end
        end
    end
    for j = 1:length(PtN)
        mol_data.positions(PtN(j),1) = 1 - mol_data.positions(PtN(j),1) - adjust;
        mol_data.positions(PtN(j),2) = 1 - mol_data.positions(PtN(j),2) - adjust;
        if mol_data.positions(PtN(j),1) < 0
                mol_data.positions(PtN(j),1) = mol_data.positions(PtN(j),1) +1;
            end
            if mol_data.positions(PtN(j),2) < 0
                mol_data.positions(PtN(j),2) = mol_data.positions(PtN(j),2) +1;
            end
    end
    
    
    %% Resaving
    XSD_Write(flname,mol_data)
    movefile(flname,[input_fldr 'switched\']);
end