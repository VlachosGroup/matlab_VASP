function XSD_to_VASPinput(paths,input)
%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
outfldr = [paths.xsd_input(1:end-4) '\'];
%% Read XSD file
[mol_data] = XSD_Read_grep(paths.xsd_input);
%% Pre-treat data
%%% fix any weird chemical symbols
for i=1:size(mol_data.positions,1)
    if strcmp(mol_data.chemical_symbols{i},'H,2')
        mol_data.chemical_symbols{i} = 'H';
    end
end

%%% Freeze Atoms
mol_data.freeze = zeros(size(mol_data.positions,1),1);
if strcmp(input.nfreeze,'all_surf')
    % find the bottom most element and freeze that element
    ZCoord = unique(mol_data.positions(:,3));
    Bottomatoms = find(mol_data.positions(:,3) == ZCoord(1));
    Surf_atom = char(mol_data.chemical_symbols(Bottomatoms(1)));
    fixedatoms = find(strcmp(mol_data.chemical_symbols,Surf_atom)==1)';
    for i=1:size(mol_data.positions,1)
        mol_data.freeze(fixedatoms) = 1;
    end
elseif input.nfreeze == 0
    mol_data.freeze = zeros(size(mol_data.positions,1),1);
else
    Tol = 1e-13;
    ZCoord = unique(Tol*round(1/Tol*mol_data.positions(:,3)));
    % Returns unique rows of Z coordinate with degits upto order of tolerance
    fixedatoms = any(abs(repmat(mol_data.positions(:,3),1,input.nfreeze)-repmat(ZCoord(1:input.nfreeze).',size(mol_data.positions,1),1)) < 2*Tol,2);
    for i=1:size(mol_data.positions,1)
        mol_data.freeze(fixedatoms) = 1;
    end
end

%%% set up ROPT
if isfield(input.INCAR,'ROPT')
    input.INCAR.ROPT = repmat([num2str(input.INCAR.ROPT) ' '],[1 length(mol_data.unique_elements)]);
end
%%% set up spin
if strcmp(input.INCAR.ISPIN,'auto')
    if any(strcmp('Fe',mol_data.chemical_symbols)) || any(strcmp('Co',mol_data.chemical_symbols)) || any(strcmp('Ni',mol_data.chemical_symbols))
        input.INCAR.ISPIN = 2;
        input.INCAR.ICHARG = 2;
        input.INCAR.MAGMOM = [];
        for i=1:length(mol_data.unique_elements)
            if strcmp('Fe',mol_data.unique_elements{i})
                input.INCAR.MAGMOM = [input.INCAR.MAGMOM ...
                    sprintf('%s*3.0 ',num2str(nnz(strcmp(mol_data.unique_elements{i},mol_data.chemical_symbols))))];
            elseif strcmp('Co',mol_data.unique_elements{i})
                input.INCAR.MAGMOM = [input.INCAR.MAGMOM ...
                    sprintf('%s*1.9 ',num2str(nnz(strcmp(mol_data.unique_elements{i},mol_data.chemical_symbols))))];
            elseif strcmp('Ni',mol_data.unique_elements{i})
                input.INCAR.MAGMOM = [input.INCAR.MAGMOM ...
                    sprintf('%s*0.75 ',num2str(nnz(strcmp(mol_data.unique_elements{i},mol_data.chemical_symbols))))];
            else
                input.INCAR.MAGMOM = [input.INCAR.MAGMOM ...
                    sprintf('%s*0.0 ',num2str(nnz(strcmp(mol_data.unique_elements{i},mol_data.chemical_symbols))))];
            end
        end
    else
        input.INCAR.ISPIN = 1;
    end
end


%% write VASP input
mkdir(outfldr);  
%%% Sort mol_data
[mol_data.unique_elements, ~, ib] = unique(mol_data.chemical_symbols);
[~, I] = sort(ib);
mol_data.chemical_symbols = mol_data.chemical_symbols(I);
mol_data.positions = mol_data.positions(I,:);
mol_data.freeze = mol_data.freeze(I);

%%% write POSCAR
POSCAR_Write([outfldr 'POSCAR'],mol_data)


%%% write POTCARs
% check for better potential
elements = mol_data.unique_elements;
if any(strcmp(elements,'Ru')); elements{strcmp(elements,'Ru')} = 'Ru_pv'; end
if any(strcmp(elements,'Rh')); elements{strcmp(elements,'Rh')} = 'Rh_pv'; end
POTCAR_Write(paths.potcar,outfldr,elements)

%%% Write INCAR
INCAR_Write(outfldr,input.INCAR)

%%% Write KPOINTS
KPOINTS_Write(outfldr,input.kpoints)

%%% Write QSUB file for squidward
QSUB_Write(outfldr,input)

end

