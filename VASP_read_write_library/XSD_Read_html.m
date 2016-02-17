function [mol_data] = XSD_Read_html(paths)
% Originally written by Michail Stamatakis 16-Nov-2011
% Edited by Geun Ho Gu. 30-Dec-2015. University of Delaware.
% Read data from xsd file
XSDdoc = xmlread(paths.xsd_input);

%finding child nose
for k = 0:XSDdoc.getChildNodes.getLength-1
    if strcmpi(XSDdoc.getChildNodes.item(k).getNodeName,'xsd')
        kxsdroot = k; % don't break here, since <!DOCTYPE XSD []> is also a node with name XSD
    end
end

XSDRoot = XSDdoc.getChildNodes.item(kxsdroot);

%finding AtomisticTreeRoot childnode
for k = 0:XSDRoot.getChildNodes.getLength-1
    if strcmpi(XSDRoot.getChildNodes.item(k).getNodeName,'AtomisticTreeRoot')
        katomisticrreetoot = k;
        break
    end
end

%finding AtomisticTreeRoot SymmetrySystem
AtomisticTreeRoot = XSDRoot.getChildNodes.item(katomisticrreetoot);
for i = 0:AtomisticTreeRoot.getChildNodes.getLength-1
    if ~isempty(AtomisticTreeRoot.getChildNodes.item(i))
        if strcmpi(char(AtomisticTreeRoot.getChildNodes.item(i).getNodeName),...
                'SymmetrySystem')
            %to the Identitiy Mappaing.
            IdentityMapping = AtomisticTreeRoot. ...
                getChildNodes.item(i).item(1).item(1).item(1);
        end
    end
end
mol_data = struct;
NAtoms = 0;
mol_data.cell = zeros(3,3);
%% reading files to matlab 
for i = 0:IdentityMapping.getChildNodes.getLength-1
    
    if ~isempty(IdentityMapping.getChildNodes.item(i))
        
        if strcmpi(IdentityMapping.getChildNodes.item(i).getNodeName,'Atom3D')
            
            NAtoms = NAtoms + 1;

            for j = 0:IdentityMapping.getChildNodes.item(i).getAttributes.getLength-1
                
                if ~isempty(IdentityMapping.getChildNodes.item(i).getAttributes.item(j))
                    
                    if strcmpi(char(IdentityMapping.getChildNodes.item(i).getAttributes.item(j).getName),'XYZ')
                        mol_data.positions(NAtoms,1:3) = str2num(IdentityMapping.getChildNodes.item(i).getAttributes.item(j).getValue); %#ok<ST2NM>
                    end
                    if strcmpi(char(IdentityMapping.getChildNodes.item(i).getAttributes.item(j).getName),'Components')
                        mol_data.chemical_symbols{NAtoms} = char(IdentityMapping.getChildNodes.item(i).getAttributes.item(j).getValue);
                    end
                end
            end
            
        end
        
        if strcmpi(IdentityMapping.getChildNodes.item(i).getNodeName,'SpaceGroup')
            
            for j = 0:IdentityMapping.getChildNodes.item(i).getAttributes.getLength-1
                
                if ~isempty(IdentityMapping.getChildNodes.item(i).getAttributes.item(j))
                    
                    if strcmpi(char(IdentityMapping.getChildNodes.item(i).getAttributes.item(j).getName),'AVector')
                        mol_data.cell(1,:) = str2num(IdentityMapping.getChildNodes.item(i).getAttributes.item(j).getValue); %#ok<ST2NM>
                    elseif strcmpi(char(IdentityMapping.getChildNodes.item(i).getAttributes.item(j).getName),'BVector')
                        mol_data.cell(2,:) = str2num(IdentityMapping.getChildNodes.item(i).getAttributes.item(j).getValue); %#ok<ST2NM>
                    elseif strcmpi(char(IdentityMapping.getChildNodes.item(i).getAttributes.item(j).getName),'CVector')
                        mol_data.cell(3,:) = str2num(IdentityMapping.getChildNodes.item(i).getAttributes.item(j).getValue); %#ok<ST2NM>
                    end
                    
                end
            end
            
        end
        
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

end




