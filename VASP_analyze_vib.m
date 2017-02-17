function VASP_analyze_vib
%%  Code written by Geun Ho Gu
%   University of Delaware
%   3/17, 2016
%
%   function related to analyzing vibrational frequency result
%   
%
%   Input:
%       paths (that has CONTCAR OUTCAR)
%       option: 1 = read vibrational frequency and print on console
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
% script find OUTCAR including those in subfolders
input_fldr = 'C:\Users\Gu\Desktop\check\';
option = 2;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
addpath([paths.mfile 'etc_library\grep04apr06\']);
%% analyze
switch option
    case 1
        flist = rdir([input_fldr '\**\OUTCAR']);
        for i=1:length(flist)
            [Vib] = OUTCAR_Vib_Freq_Vec_Read(flist(i).name);
            slash_index = regexp(flist(i).name,'\');
            name = flist(i).name(slash_index(end-1)+1:slash_index(end)-1);
            fprintf('%s',name);
            for j=1:length(Vib)
                if isreal(Vib(j).freqs)
                    fprintf('\t%4.2f',Vib(j).freqs);
                else
                    fprintf('\t%4.2fi',imag(Vib(j).freqs));
                end
            end
            fprintf('\n');
        end
    otherwise
        flist = rdir([input_fldr '\**\OUTCAR']);
        for i=1:length(flist)
            VASP_vib_read(flist(i).name(1:end-6),option);
        end
end


end


    
