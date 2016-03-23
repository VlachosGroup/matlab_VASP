function [mol_data] = VASP_Config_Read(flpath)
% written by Geun Ho Gu 31-Dec-2015
% Read CONTCAR,POSCAR,XDATCAR
% mol_data.cell
% mol_data.unique_elements
% mol_data.positions
% mol_data.chemical_symbols
%
%
fidconf = fopen(flpath);
% First line is a comment
fgetl(fidconf); eofstat = feof(fidconf); 
if eofstat == 1;
    warning('%s is empty.',flpath);
    return
end
% Second line gives the scaling factor for the unit cell
textLine = fgetl(fidconf);
ScalF = str2double(textLine);

% Subsequent three lines give the unit vectors
textLine = fgetl(fidconf); va = str2num(textLine); %#ok<ST2NM>
textLine = fgetl(fidconf); vb = str2num(textLine); %#ok<ST2NM>
textLine = fgetl(fidconf); vc = str2num(textLine); %#ok<ST2NM>
mol_data.cell = ScalF*[va; vb; vc];

% Element list
textLine = fgetl(fidconf); feof(fidconf);
StrWords = textscan(textLine,'%s');
mol_data.unique_elements=StrWords{1};

% chemical symbols
textLine = fgetl(fidconf); feof(fidconf);
n = str2num(textLine); %#ok<ST2NM>
NAtoms = sum(n);
for k = 1:length(n)
    for i = 1:n(k)
        mol_data.chemical_symbols{sum(n(1:k-1))+i} = mol_data.unique_elements{k};
    end
end

% See if CONTCAR/POSCAR or XDATCAR
textLine = fgetl(fidconf); feof(fidconf); 
StrWords = textscan(textLine,'%s');
if strcmp(StrWords{1}{1},'Selective')
    %CONTCAR/POSCAR
    textLine = fgetl(fidconf); StrWords = textscan(textLine,'%s');
    if strcmp(StrWords{1}{1},'Cartesian')
        cartesian = 1;
    else
        cartesian = 0;
    end
    for i=1:NAtoms
        textLine = fgetl(fidconf);
        StrWords = textscan(textLine,'%s');
        mol_data.positions(i,1) = str2num(StrWords{1}{1}); %#ok<ST2NM>
        mol_data.positions(i,2) = str2num(StrWords{1}{2}); %#ok<ST2NM>
        mol_data.positions(i,3) = str2num(StrWords{1}{3}); %#ok<ST2NM>
        if strcmp(StrWords{1}{4},'T')
            mol_data.freeze(i) = 0;
        else
            mol_data.freeze(i) = 1;
        end
    end
    if cartesian == 1;
        NewVec = [1 0 0; 0 1 0; 0 0 1];
        mol_data.positions = (mol_data.cell'\(NewVec'*mol_data.positions'))';
    end
    fclose(fidconf);
elseif strcmp(StrWords{1}{1},'Direct') || strcmp(StrWords{1}{1},'Cartesian') 
    %XDATCAR
    if strcmp(StrWords{1}{1},'Cartesian')
        cartesian = 1;
    else
        cartesian = 0;
    end
    iconf = 0;
    
    while ~eofstat
        iconf = iconf + 1;
        for i=1:NAtoms
            textLine = fgetl(fidconf); eofstat = feof(fidconf);
            StrWords = textscan(textLine,'%s');
            mol_data.positions(iconf,i,1) = str2num(StrWords{1}{1}); %#ok<ST2NM>
            mol_data.positions(iconf,i,2) = str2num(StrWords{1}{2}); %#ok<ST2NM>
            mol_data.positions(iconf,i,3) = str2num(StrWords{1}{3}); %#ok<ST2NM>
        end
        if cartesian == 1;
            NewVec = [1 0 0; 0 1 0; 0 0 1];
            mol_data.positions(iconf,:,:) = (mol_data.cell'\(NewVec'*mol_data.positions(iconf,:,:)'))';
        end
        fgetl(fidconf);
        if eofstat;
            fclose(fidconf);
            break
        end
    end
    
end

mol_data.lattice = 'direct';
end