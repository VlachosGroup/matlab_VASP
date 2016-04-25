function XSD_to_VASPinput_opt_vib
%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%
%   Creates VASP input files 
%
%   Input:
%       1) paths
%       2) input parameters 
%   Output:
%       Creates VASP input. create temp for JA calculation, create qsub
%       file for squidward
%
%   TODO: NEB input
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% creator name
% name of creator and the date is printed in INCAR file. 
input.INCAR.author = 'Geun Ho Gu';

%%% path set up
% script find all xsd file - including files within all the subflolders -
% in input_fldr
input_fldr = 'C:\Users\Gu\Desktop\Batches\4-25\';
% laptop
% paths.potcar = 'C:\Users\Gu\Desktop\Research\potpaw_PBE.52';
paths.potcar = 'C:\Users\Gu\Desktop\Research\Data\VASP\potpaw_PBE.52\';
% paths.potcar = 'C:\Users\Gu\Desktop\Research\Data\VASP\potential\pw91\';
% kernel path for vdW-DF dispersion correction
paths.kernel = 'C:\Users\Gu\Desktop\Research\Data\MATLAB_library\VASP\vdw_kernel.bindat';
% Here, you can either use the preset choices I made here, or specify input
% parameters yourself (see preset parameters section)

%%% functional choice
% INCAR presets are available for functional below
% PBE, PBE-D3, optPBE-vdW-DF, RPBE, RPBE-D3, revPBE, revPBE-D3, revPBE-vdW-DF, PBEsol, PBEsol-D3, PW91, AM05, optB88-vdW-DF, optB86b-vdW-DF, rPW86-vdW-DF2
functional = 'PBE-D3';

%%% electronic optimization preset choice
% surf_low  : for fast surface calc convergence
% gas       : for gas phae calculation. Turns on spin
elec_opt = 'surf_low';
%%% Gas specific option
% H2. Singlet state specification
% input.INCAR.NUPDOWN = 0;
% O2. Triplet state specification
% input.INCAR.NUPDOWN = 2;

%%% Calculator choice
% geometric     : ibrion 2 geometric optimizer
% vibrational   : ibrion 5 vibrtional optimizer
calculator = 'geometric';

%%% spin polarization
% 1     : turn off
% 2     : turn on
% auto  : automatically turn on if the script detects Fe, Ni, Co
spin = 'auto';

%%% speed parameter
input.INCAR.NPAR = 2;
input.ncores = 20;

%%% bader analysis
input.bader = 0;

%%% number of frozen layer
% all_surf : freeze all the surface atom
input.nfreeze = 2;

%%% If you are having convergence issue,
% 3 parameter below changes quadratic mixing to linear mixing
%input.INCAR.BMIX = 0.000001
%input.INCAR.WC = 100.000000
%input.INCAR.AMIX = 0.100000
% Also, try Algo = Normal which only use Davidson to converge.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%% Preset Parameters %%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% INCAR parameters
% any parameters you write will be printed out in INCAR
% i.e. input.INCAR does not have LORBIT field below, but if you write them,
% it will be printed.
% input parameter can either be integer or string
input.INCAR.NWRITE    = 1;
input.INCAR.LWAVE     = '.FALSE.';
input.INCAR.LCHARG    = '.FALSE.';
input.INCAR.LVTOT     = '.FALSE.';
% functional choice
switch functional
    case 'PBE'
    case 'PBE-D3'
        input.INCAR.LVDW = '.TRUE.';
        input.INCAR.VDW_VERSION = 3;
    case 'optPBE-vdW-DF'
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
    case 'revPBE-vdW-DF'
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
    case 'optB88-vdW-DF'
        input.INCAR.GGA = 'BO';
        input.INCAR.PARAM1 = 0.1833333333;
        input.INCAR.PARAM2 = 0.2200000000;
        input.INCAR.LUSE_VDW = '.TRUE.';
        input.INCAR.AGGAC = 0.0000;
    case 'optB86b-vdW-DF'
        input.INCAR.GGA = 'MK';
        input.INCAR.PARAM1 = 0.1234;
        input.INCAR.PARAM2 = 1.0000;
        input.INCAR.LUSE_VDW = '.TRUE.';
        input.INCAR.AGGAC = 0.0000;
    case 'rPW86-vdW-DF2'
        input.INCAR.GGA = 'ML';
        input.INCAR.Zab_vdW = -1.8867;
        input.INCAR.LUSE_VDW = '.TRUE.';
        input.INCAR.AGGAC = 0.0000;
end
% electronic relaxation
% surf_low  : for fast surface calc convergence
% gas       : for gas phae calculation
input.INCAR.ENCUT     = 400;
input.INCAR.ALGO      = 'Fast';
input.INCAR.ISMEAR    = 1;
input.INCAR.VOSKOWN   = 1;
input.INCAR.PREC      = 'med';
input.INCAR.LREAL      = 'auto';
input.INCAR.ROPT      = '2e-4';
input.INCAR.ISTART    = 0;
input.INCAR.NELM      = 400;
input.INCAR.NELMDL    = -10;
input.INCAR.ISYM      = 0;
switch spin
    case 1
        input.INCAR.ISPIN     = 1;
    case 2
        input.INCAR.ISPIN     = 2;
    case 'auto'
        input.INCAR.ISPIN     = 'auto';
end
switch elec_opt
    case 'surf_low'
        input.INCAR.EDIFF     = '1e-4';
        input.INCAR.SIGMA     = 0.1;
        input.kpoints = [3 3 1];
    case 'gas'
        % over rides ispin
        input.INCAR.EDIFF     = '1e-6';
        input.INCAR.SIGMA     = 0.01;
        input.INCAR.ISPIN     = 2;
        input.kpoints = [1 1 1];
end

% calcualtor set up
switch calculator
    case 'geometric'
        input.INCAR.NSW      = 1000;
        input.INCAR.ISIF      = 2;
        input.INCAR.IBRION   = 1;
        input.INCAR.NFREE    = 2;
        input.INCAR.POTIM    = 0.2;
        input.INCAR.EDIFFG   = -0.04;
    case 'vibrational'
        % over-rides ediff, nfreeze
        input.INCAR.EDIFF    = '1e-6';
        input.INCAR.NSW      = 1;
        input.INCAR.ISIF     = 2;
        input.INCAR.IBRION   = 5;
        input.INCAR.NFREE    = 2;
        input.INCAR.POTIM    = 0.015;
        input.INCAR.EDIFFG   = -0.03;
        input.nfreeze = 'all_surf';
end

switch input.bader
    case 0
    case 1
        % over-rides LCHARG
        input.INCAR.LCHARG    = '.TRUE.';
        input.INCAR.NGXF = 192;
        input.INCAR.NGYF = 192;
        input.INCAR.NGZF = 448;
end
% NEB 
% input.INCAR.LCLIMB = '.TRUE.';
% input.INCAR.ICHAINA = 0;
% input.INCAR.ICHAINA = nimages;
% input.INCAR.SPRING = -5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
addpath([paths.mfile 'etc_library\grep04apr06\']);
%%% Automatically adds \ if missing
fields = fieldnames(paths);
for i=1:length(fields);
    if ~isempty(paths.(fields{i})) && paths.(fields{i})(end) ~= '\';
        paths.(fields{i})(end+1) = '\';
    end
end
if ~strcmp(input_fldr(end),'\'); input_fldr(end+1) = '\'; end

%% Find all xsd files and convert them
%%% file name cannot contain ()
flist = rdir([input_fldr '\**\*.xsd']);
newline = char(10);
joblist_id = fopen ([input_fldr 'temp'],'w');
for i=1:length(flist)
    paths.xsd_input = flist(i).name;
    XSD_to_VASPinput(paths,input)
    slash_index = strfind(flist(i).name,'\');
    path = flist(i).name(length(input_fldr)+1:end-4);
    path = strrep(path,'\','/');
    fprintf(joblist_id,['./' path newline]);
    % copy kernel if vdW dispersion is used
    if any(strcmp(functional,{'optPBE-vdW','revPBE-vdW','optB88-vdW','optB86b-vdW','rPW86-DF2'}))
    copyfile(paths.kernel,output_path);
    end
end
fclose(joblist_id);
end
