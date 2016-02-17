function [mol_data] = XSD_Read_grep(fpath)
% Written by Geun Ho Gu 30-Dec-2015. University of Delaware.
% Read data from xsd file. 
% Need grep function. Add path if grep is missing
if ~exist('grep.m','file')
    mfile_path = [fileparts(which([mfilename '.m'])) '\'];
    slash_index = regexp(mfile_path,'\');
    addpath([mfile_path(1:slash_index(end-1)) 'etc_library\grep04apr06\']);
end
% addpath([paths.mfile 'etc_library\grep04apr06\']);
% addpath('C:\Users\Gu\Desktop\Research\Data\MATLAB_library\MATLAB_VASP\etc_library\grep04apr06\');
% Grep appropriate lines
[~, P] = grep('-Q -s', {'Components', 'SpaceGroup','Atom3d','Connects'}, fpath);
%% Initialize variables
mol_data.positions = zeros(P.lcount(1),3);
mol_data.chemical_symbols = cell(1,P.lcount(1));
AtomID = zeros(P.lcount(1),1);
%% Read position and atoms
for i=1:P.lcount(1)
    string = P.match{i};
    string = strrep(string, '<Atom3d','');
    string = strrep(string, '/>','');
    fields = textscan(regexprep(string,'=".*?"',''),'%s');
    quotes = regexp(string,'"');
    for j=1:length(fields{1})
        if strcmp('Components',fields{1}{j})
            mol_data.chemical_symbols{i} = string(quotes(j*2-1)+1:quotes(j*2)-1);
        elseif strcmp('XYZ',fields{1}{j})
            mol_data.positions(i,1:3) = str2num(string(quotes(j*2-1)+1:quotes(j*2)-1)); %#ok<ST2NM>
        elseif strcmp('ID',fields{1}{j})
            AtomID(i) = str2double(string(quotes(j*2-1)+1:quotes(j*2)-1));
        end
    end
end
%% Read supercell basis vector
string = P.match{P.lcount(1)+P.lcount(2)};
string = strrep(string, '<SpaceGroup','');
string = strrep(string, '/>','');
fields = textscan(regexprep(string,'=".*?"',''),'%s');
quotes = regexp(string,'"');
for j=1:length(fields{1})
    if strcmp('AVector',fields{1}{j})
        mol_data.cell(1,:) = str2num(string(quotes(j*2-1)+1:quotes(j*2)-1)); %#ok<ST2NM>
    elseif strcmp('BVector',fields{1}{j})
        mol_data.cell(2,:) = str2num(string(quotes(j*2-1)+1:quotes(j*2)-1)); %#ok<ST2NM>
    elseif strcmp('CVector',fields{1}{j})
        mol_data.cell(3,:) = str2num(string(quotes(j*2-1)+1:quotes(j*2)-1)); %#ok<ST2NM>
    end
end

%% Lump the same elements together without disruptting order
[~,I,~] = unique(mol_data.chemical_symbols);
mol_data.unique_elements = mol_data.chemical_symbols(sort(I));
I=[];
for i=1:length(mol_data.unique_elements)
    I = [I find(strcmp(mol_data.unique_elements(i),mol_data.chemical_symbols))]; %#ok<AGROW>
end
mol_data.chemical_symbols = mol_data.chemical_symbols(I);
mol_data.positions = mol_data.positions(I,:);


%% Make Connectivity Matrix
% only if bond data exist, it will go through bond daya
if length(P.lcount) == 4
    %% Get atom remap data
    % Gets line that looks like this:
    % <Atom3d ID="588" Mapping="626" ImageOf="16" Visible="0"/>
    Remap = zeros(P.lcount(3)-P.lcount(1),2);
    % P.lcount(1) is added again because when you grep atom3d, it also
    % greps non-remapped atom3d lines as well, so to avoid double count, we
    % add P.lcount(1) agaain
    for i=P.lcount(1)+P.lcount(2)+1+P.lcount(1):P.lcount(1)+P.lcount(2)+P.lcount(3)
        string = P.match{i};
        string = strrep(string, '<Atom3d','');
        string = strrep(string, '/>','');
        fields = textscan(regexprep(string,'=".*?"',''),'%s');
        quotes = regexp(string,'"');
        ni = i - (P.lcount(1)+P.lcount(2)+P.lcount(1));
        for j=1:length(fields{1})
            if strcmp('ImageOf',fields{1}{j})
                Remap(ni,2) = str2double(string(quotes(j*2-1)+1:quotes(j*2)-1));
            elseif strcmp('ID',fields{1}{j})
                Remap(ni,1) = str2double(string(quotes(j*2-1)+1:quotes(j*2)-1));
            end
        end
    end
    %% Get bond data
    % For line that looks like this:
    % <Bond ID="408" Mapping="432" Parent="2" Connects="67,66"/>
    Bond = zeros(P.lcount(4),2);
    for i=P.lcount(1)+P.lcount(2)+P.lcount(3)+1:P.lcount(1)+P.lcount(2)+P.lcount(3)+P.lcount(4)
        string = P.match{i};
        string = strrep(string, '<Bond','');
        string = strrep(string, '/>','');
        fields = textscan(regexprep(string,'=".*?"',''),'%s');
        quotes = regexp(string,'"');
        ni = i - (P.lcount(1)+P.lcount(2)+P.lcount(3));
        for j=1:length(fields{1})
            if strcmp('Connects',fields{1}{j})
                Bond(ni,:) = str2num(string(quotes(j*2-1)+1:quotes(j*2)-1)); %#ok<ST2NM>
            end
        end
    end
    
    %% Make Connectivity matrix
    % remap all the bond connections
    for i=1:P.lcount(3)-P.lcount(1)
        Bond(Bond == Remap(i,1)) = Remap(i,2);
    end
    % Make connectivity matrix
    mol_data.connectivity = zeros(P.lcount(1),P.lcount(1));
    for i=1:P.lcount(4)
        mol_data.connectivity(find(AtomID == Bond(i,1)),find(AtomID == Bond(i,2))) = 1; %#ok<FNDSB>
        mol_data.connectivity(find(AtomID == Bond(i,2)),find(AtomID == Bond(i,1))) = 1; %#ok<FNDSB>
    end
    % Sort 
    mol_data.connectivity = mol_data.connectivity(I,I);
end
end




