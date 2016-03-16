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
positions = zeros(length(flist),size(mol_data.positions,1),3);
for i=1:length(flist)
    [mol_data] = VASP_Config_Read(image_path{i});
    positions(i,:,:) = mol_data.positions;
end
mol_data.positions = positions;

%% Read OSZICAR & find the image with highest energy and record

%%%%
%% Read OSZICAR & set up name
name = paths.input(slash_index(end-1)+1:slash_index(end)-1);
if options.read_OSZICAR_and_include_energy_in_file_name && exist([paths.input(1:slash_index(end)) 'OSZICAR'],'file')
    [E]=OSZICAR_Read([paths.input(1:slash_index(end)) 'OSZICAR']);
    name = [name sprintf('%3.3f', E.total)];
end
vaspfile = paths.input(slash_index(end)+1:end);
if strcmp(vaspfile,'CONTCAR') || strcmp(vaspfile,'POSCAR')
    name = [name '.xsd'];
elseif strcmp(vaspfile,'XDATCAR')
    name = [name '.xtd'];
end
paths.output = [paths.input(1:slash_index(end)) name];
%% Read and write VASP config
[mol_data] = VASP_Config_Read(paths.input);

if ndims(mol_data.positions) == 2 %#ok<ISMAT>
    XSD_Write(paths.output,mol_data)
elseif ndims(mol_data.positions) == 3
    XTD_Write(paths.output,mol_data,10)
end
%%%%

end

