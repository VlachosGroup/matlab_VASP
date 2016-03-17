function VASP_NEBoutput_to_XTD(paths,options)
%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%   Need grep function (added on path)

slash_index = regexp(paths.input,'\');
%% Find config file in each image
flist = rdir(paths.input, 'regexp(name, ''\\\d{2}$'')');
for i=1:length(flist)
    if exist([flist(i).name '\CONTCAR'],'file')
        image_path{i} = [flist(i).name '\CONTCAR'];
    else
        image_path{i} = [flist(i).name '\POSCAR'];
    end
end
%% Read image
[mol_data] = VASP_Config_Read(image_path{1});
positions = zeros(length(flist),size(mol_data.positions,1),3);
positions(1,:,:) = mol_data.positions;
for i=2:length(image_path)
    [mol_data] = VASP_Config_Read(image_path{i});
    positions(i,:,:) = mol_data.positions;
end
mol_data.positions = positions;

%% Read OSZICAR & find the image with highest energy and record
name = paths.input(slash_index(end-1)+1:slash_index(end)-1);
if options.read_OSZICAR_and_include_energy_in_file_name
    for i=2:length(flist)-1
        if exist([flist(i).name '\OSZICAR'],'file')
            [E(i)]=OSZICAR_Read([flist(i).name '\OSZICAR']);
        end
    end
    [Emax, I] = max([E.total]);
    name = [name sprintf('_img%d_%3.3f',I, Emax)];
end
paths.output = [paths.input(1:slash_index(end)) name '.xtd'];

%% Read and write VASP config
XTD_Write(paths.output,mol_data,10)


end

