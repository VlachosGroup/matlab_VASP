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
input_fldr = 'C:\Users\Gu\Desktop\Batches\3-18\';
% laptop
% paths.potcar = 'C:\Users\Gu\Desktop\Research\potpaw_PBE.52';
paths.potcar = 'C:\Users\Gu\Desktop\Research\Data\VASP\potpaw_PBE.52\';

% Here, you can either use the preset choices I made here, or specify input
% parameters yourself (see preset parameters section)

%%% functional choice
% PBE, PBE-D3, RPBE, RPBE-D3
functional = 'PBE-D3';

%%% electronic optimization preset choice
% surf_low  : for fast surface calc convergence
% gas       : for gas phae calculation. Turns on spin
elec_opt = 'surf_low';

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
    case 'RPBE'
        input.INCAR.GGA = 'RP';
    case 'RPBE-D3'
        input.INCAR.LVDW = '.TRUE.';
        input.INCAR.VDW_VERSION = 3;
        input.INCAR.GGA = 'RP';
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
% 
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
    path = flist(i).name(slash_index(end)+1:end-4);
    path = strrep(path,'\','/');
    fprintf(joblist_id,['./' path newline]);
end
fclose(joblist_id);
end
