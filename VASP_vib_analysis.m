function VASP_vib_analysis
%%  Code written by Geun Ho Gu
%   University of Delaware
%   3/17, 2016
%
%   function related to analyzing vibrational frequency result
%   
%
%   Input:
%       paths (that has CONTCAR OUTCAR)
%       option: 1 = read vibrational frequency
%               2 = read vibrational frequency & and make vibration animation (xtd)
%               3 = read vibrational frequency & and make vibration animation (xtd)
%                   for the imaginary frequency only
%   Output:
%       See explanation above
%
% Script goes through all subfolders (including specified folders) and find
% POSCAR/CONTCAR/XDATCAR and convert.
% For NEB, the script search for POSCAR in folder name 00, and convert.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% path set up
% script find all VASP files - including files within all the subflolders 
input_fldr = 'C:\Users\Gu\Desktop\Checking\3-7\H12PCOH_hcpA\';
convert_CONTCAR = 0;
convert_XDATCAR = 0;
convert_POSCAR = 0;
convert_NEB = 1;
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

%% Convert
%%% CONTCAR first
switch convert_CONTCAR; case 1;
    flist = rdir([input_fldr '\**\CONTCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        VASPoutput_to_XSD_XTD(paths,options);      
    end
end

switch convert_POSCAR; case 1;
    flist = rdir([input_fldr '\**\POSCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        VASPoutput_to_XSD_XTD(paths,options);      
    end
end

switch convert_XDATCAR; case 1;
    flist = rdir([input_fldr '\**\XDATCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        VASPoutput_to_XSD_XTD(paths,options);      
    end
end

switch convert_NEB; case 1;
    flist = rdir([input_fldr '\**\00\POSCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        slash_index = regexp(paths.input,'\');
        paths.input = paths.input(1:slash_index(end-1));
        VASP_NEBoutput_to_XTD(paths,options);      
    end
end


end


    
