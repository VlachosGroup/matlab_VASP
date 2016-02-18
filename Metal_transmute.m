% Go through folder and subfolders to replace metal atoms with a different
% element and resize the box according to the lattice constant

function Metal_transmute

clear; clc; 

addpath('C:\Users\Marcel\Dropbox\Research_Files\Matlabscripts\VASP\GuScripts\VASP_read_write_library'); % give Matlab access to the xsd read/write directory
parent = 'C:\Users\Marcel\Dropbox\Research_Files\MS_projects\GCN Files\Documents\Ag calcs';      % Directory of the xsd files

lat_old = 3.9239;           % Pt lattice constant
lat_new = 3.7638;           % Ag lattice constant

metal_old = 'Pt';
metal_new = 'Ag';

searchdir(parent)

    function searchdir(directory)
        
        x = dir(directory);         % List contents of current directory
        x([1 2]) = [];              % Remove parent and current folders from the list
        numitems = length(x);
        
        for i = 1:numitems
            if x(i).isdir
                searchdir([directory '/' x(i).name]);
            else        % if it's an xsd file
                process([directory '/' x(i).name]);
            end
        end
        
    end

    function process(xsdfile)
        
        mol_data = XSD_Read_grep(xsdfile);
        
        % Transmute old metal to new metal
        for i = 1:length(mol_data.chemical_symbols)
            if  strcmp(mol_data.chemical_symbols{i},metal_old)
                mol_data.chemical_symbols{i} = metal_new;
            end
        end
        
        mol_data.cell = mol_data.cell * lat_new / lat_old;
        delete(xsdfile);
        XSD_Write(xsdfile,mol_data)
    end

end