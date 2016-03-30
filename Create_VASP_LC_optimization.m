function Create_VASP_LC_optimization
%%  Code written by Geun Ho Gu
%   University of Delaware
%   March 29th, 2016
%
%   Creates VASP lattice constant input files 
%
%   Input:
%       1) paths
%       2) metal
%       3) packing
%       4) functional
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% creator name
% name of creator and the date is printed in INCAR file. 
input.INCAR.author = 'Geun Ho Gu';

%%% path set up
% where output goes
output_path = 'C:\Users\Gu\Desktop\Batches\3-29\Davood\';
% folder for POTCAR
paths.potcar = 'C:\Users\Gu\Desktop\Research\Data\VASP\potpaw_PBE.52\';
% for pw91
% paths.potcar = 'C:\Users\Gu\Desktop\Research\Data\VASP\potential\pw91\';
% kernel path for vdW-DF dispersion correction
paths.kernel = 'C:\Users\Gu\Desktop\Research\Data\MATLAB_library\VASP\vdw_kernel.bindat';

%%% metal preset choice
% preset LC guess and packing info are available for metal below:
% Ag, Au, Co, Cu, Fe, Ir, Ni, Pd, Pt, Rh, Ru, Re
metal = 'Pt';

%%% functional preset choice
% INCAR presets are available for functional below
% PBE, PBE-D3, optPBE-vdW, RPBE, RPBE-D3, revPBE, revPBE-D3, revPBE-vdW, PBEsol, PBEsol-D3, PW91, AM05, optB88-vdW, optB86b-vdW, rPW86-DF2
% remember that PW and LDA functional use different potential
functional = 'PW91';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%% Preset Parameters %%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% INCAR parameters
% any parameters you write will be printed out in INCAR
% i.e. input.INCAR does not have LORBIT field below, but if you write them,
% it will be printed.
% input parameter can either be integer or string
input.INCAR.ENCUT     = 500;
input.INCAR.ENAUG     = 516;
input.INCAR.ISMEAR    = 0;
input.INCAR.NWRITE    = 1;
input.INCAR.LWAVE     = '.FALSE.';
input.INCAR.LCHARG    = '.FALSE.';
input.INCAR.LVTOT     = '.FALSE.';
input.INCAR.PREC      = 'high';
input.INCAR.EDIFF     = '1e-6';
input.INCAR.ISPIN     = 2;
input.INCAR.NSW      = 1000;
input.INCAR.ISIF      = 6;
input.INCAR.IBRION   = 1;
input.INCAR.NFREE    = 10;
input.INCAR.POTIM    = 0.35;
input.INCAR.EDIFFG   = -0.005;
% Kpoints
input.kpoints = [15 15 1];
% functional choice. Also copies 
switch functional
    case 'PBE'
    case 'PBE-D3'
        input.INCAR.LVDW = '.TRUE.';
        input.INCAR.VDW_VERSION = 3;
    case 'optPBE-vdW'
        input.INCAR.GGA = 'OR';
        input.INCAR.LUSE_VDW = '.TRUE.';
        input.INCAR.AGGAC = 0.0000;
    case 'RPBE'
        input.INCAR.GGA = 'RP';
    case 'RPBE-D3'
        input.INCAR.LVDW = '.TRUE.';
        input.INCAR.VDW_VERSION = 3;
        input.INCAR.GGA = 'RP';
    case 'revPBE'
        input.INCAR.GGA = 'RE';
    case 'revPBE-D3'
        input.INCAR.LVDW = '.TRUE.';
        input.INCAR.VDW_VERSION = 3;
        input.INCAR.GGA = 'RE';
    case 'revPBE-vdW'
        input.INCAR.GGA = 'RE';
        input.INCAR.LUSE_VDW = '.TRUE.';
        input.INCAR.AGGAC = 0.0000;
    case 'PBEsol'
        input.INCAR.GGA = 'PS';
    case 'PBEsol-D3'
        input.INCAR.LVDW = '.TRUE.';
        input.INCAR.VDW_VERSION = 3;
        input.INCAR.GGA = 'PS';
    case 'PW91'
        input.INCAR.GGA = '91';
    case 'AM05'
        input.INCAR.GGA = 'AM';
    case 'optB88-vdW'
        input.INCAR.GGA = 'BO';
        input.INCAR.PARAM1 = 0.1833333333;
        input.INCAR.PARAM2 = 0.2200000000;
        input.INCAR.LUSE_VDW = '.TRUE.';
        input.INCAR.AGGAC = 0.0000;
    case 'optB86b-vdW'
        input.INCAR.GGA = 'MK';
        input.INCAR.PARAM1 = 0.1234;
        input.INCAR.PARAM2 = 1.0000;
        input.INCAR.LUSE_VDW = '.TRUE.';
        input.INCAR.AGGAC = 0.0000;
    case 'rPW86-DF2'
        input.INCAR.GGA = 'ML';
        input.INCAR.Zab_vdW = -1.8867;
        input.INCAR.LUSE_VDW = '.TRUE.';
        input.INCAR.AGGAC = 0.0000;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%% Metal Information %%%%%%%%%%%%%%%%%%%%%%%%% %%
% metal
switch metal
    case 'Ag'
        packing = 'fcc';
        LC_guess = 4.0853;
    case 'Au'
        packing = 'fcc';
        LC_guess = 4.0782;
    case 'Co'
        packing = 'hex';
        LC_guess = [2.5071 4.0695];
    case 'Cu'
        packing = 'fcc';
        LC_guess = 3.6149;
    case 'Fe'
        packing = 'bcc';
        LC_guess = 2.8665;
    case 'Ir'
        packing = 'fcc';
        LC_guess = 3.839;
    case 'Ni'
        packing = 'fcc';
        LC_guess = 3.524;
    case 'Pd'
        packing = 'fcc';
        LC_guess = 3.8907;
    case 'Pt'
        packing = 'fcc';
        LC_guess = 3.9242;
    case 'Re'
        packing = 'hex';
        LC_guess = [2.761 4.4456];
    case 'Ru'
        packing = 'hex';
        LC_guess = [2.7059 4.2815];
    case 'Rh'
        packing = 'fcc';
        LC_guess = 3.8034;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
%%% Automatically adds \ if missing
fields = fieldnames(paths);
for i=1:length(fields);
    if ~isempty(paths.(fields{i})) && paths.(fields{i})(end) ~= '\';
        paths.(fields{i})(end+1) = '\';
    end
end
if ~strcmp(output_path(end),'\'); output_path(end+1) = '\'; end

%% Set up POSCAR
switch packing
    case 'fcc'
        mol_data.cell = [LC_guess 0 0; 0 LC_guess 0; 0 0 LC_guess];
        mol_data.unique_elements = metal;
        mol_data.chemical_symbols ={metal, metal, metal, metal}; 
        mol_data.positions = [0.0 0.0 0.0; 0.0 0.5 0.5; 0.5 0.0 0.5; 0.5 0.5 0.0];
        mol_data.freeze = ones(1,4);
    case 'bcc'
        mol_data.cell = [LC_guess 0 0; 0 LC_guess 0; 0 0 LC_guess];
        mol_data.unique_elements = metal;
        mol_data.chemical_symbols ={metal, metal}; 
        mol_data.positions = [0.0 0.0 0.0; 0.5 0.5 0.5];
        mol_data.freeze = ones(1,2);
    case 'hex'
        mol_data.cell = [LC_guess(1) 0 0; -sind(30)*LC_guess(1) cosd(30)*LC_guess(1) 0; 0 0 LC_guess(2)];
        mol_data.unique_elements = metal;
        mol_data.chemical_symbols ={metal, metal}; 
        mol_data.positions = [2/3 1/3 0.25; 1/3 2/3 0.75];
        mol_data.freeze = ones(1,2);
end

%% Create input
%%% copy kernel if vdW dispersion is used
if any(strcmp(functional,{'optPBE-vdW','revPBE-vdW','optB88-vdW','optB86b-vdW','rPW86-DF2'}))
    copyfile(paths.kernel,output_path);
end
%%% write POSCAR
POSCAR_Write([output_path 'POSCAR'],mol_data)

%%% write POTCARs
% check for better potential
elements = mol_data.unique_elements;
if any(strcmp(elements,'Ru')); elements = 'Ru_pv'; end
if any(strcmp(elements,'Rh')); elements = 'Rh_pv'; end
POTCAR_Write(paths.potcar,output_path,mol_data.unique_elements)

%%% Write INCAR
INCAR_Write(output_path,input.INCAR)

%%% Write KPOINTS
KPOINTS_Write(output_path,input.kpoints)
end
