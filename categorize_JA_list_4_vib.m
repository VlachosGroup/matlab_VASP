% Vlachos Group, University of Delaware
% 2016-2-17
% Geun Ho Gu
%
% Prepare job array file lists based on the number of adsorbate atoms.
% Molecule with adsorbate atoms less than 16 are put into temp-8h, and others
% are put into temp.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% path set up
input_fldr = 'C:\Users\Gu\Desktop\Checking\2-18\';
output_flpath = 'C:\Users\Gu\Desktop\Checking\2-18\temp';
adsorbate_atom_element = {'C','H','O'};
Min_num_atoms = 16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\MATLAB_VASP\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
addpath([paths.mfile 'etc_library\grep04apr06\']);
fid1 = fopen(output_flpath ,'w');
fid2 = fopen([output_flpath '-8h'],'w');
newline = char(10);
flist = rdir([input_fldr '\**\CONTCAR']);
for i=1:length(flist)
    [mol_data] = VASP_Config_Read(flist(i).name);
    slash_index = regexp(flist(i).name,'\');
    name = flist(i).name(slash_index(end-1)+1:slash_index(end)-1);
    sum_of_adsorbate = 0;
    for j =1:length(adsorbate_atom_element)
        sum_of_adsorbate = sum_of_adsorbate + nnz(strcmp(mol_data.chemical_symbols,adsorbate_atom_element{j}));
    end
    if sum_of_adsorbate <= Min_num_atoms
        fprintf(fid2,['./' name newline]);
    else
        fprintf(fid1,['./' name newline]);
    end
end
fclose(fid1);
fclose(fid2);
