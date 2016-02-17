%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% path set up
% script find all VASP files - including files within all the subflolders 
input_fldr = 'C:\Users\Gu\Desktop\Checking\2-10\setup\';
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
addpath([paths.mfile 'etc_library\grep04apr06\']);
fid1 = fopen('C:\Users\Gu\Desktop\Checking\2-10\setup\temp','w');
fid2 = fopen('C:\Users\Gu\Desktop\Checking\2-10\setup\temp-8h','w');
newline = char(10);
flist = rdir([input_fldr '\**\POSCAR']);
for i=1:length(flist)
    [mol_data] = VASP_Config_Read(flist(i).name);
    slash_index = regexp(flist(i).name,'\');
    name = flist(i).name(slash_index(end-1)+1:slash_index(end)-1);
    sum_of_adsorbate = nnz(strcmp(mol_data.chemical_symbols,'C')) + nnz(strcmp(mol_data.chemical_symbols,'H')) + nnz(strcmp(mol_data.chemical_symbols,'O'));
    if sum_of_adsorbate <= 18
        fprintf(fid2,['./' name newline]);
    else
        fprintf(fid1,['./' name newline]);
    end
end
fclose(fid1);
fclose(fid2);
