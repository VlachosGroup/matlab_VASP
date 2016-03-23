function mol_data = XYZ_Read(flpath)
fidconf = fopen(flpath);
textLine = fgetl(fidconf);
natom = str2double(textLine);
fgetl(fidconf); % second line is comment
mol_data.lattice = 'cartesian';
%%% record chemical symbols
mol_data.chemical_symbols = cell(natom,1); 
%%% record positions
mol_data.positions = zeros(natom,3);
for i=1:natom
    textLine = fgetl(fidconf);
    StrWords = textscan(textLine,'%s %f %f %f');
    mol_data.chemical_symbols{i} = StrWords{1}{1};
    mol_data.positions(i,:) = [StrWords{2:4}];
end
mol_data.unique_elements = unique(mol_data.chemical_symbols);
end