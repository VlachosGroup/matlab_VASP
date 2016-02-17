function VASPoutput_to_XSD_XTD
%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
%
%   Creates  XSD files. Requires rdir and grep functions
%
%   Input:
%       paths (that has CONTCAR POSCAR XDATCAR)
%   Output:
%       Creates XSD files
%
%   TODO: NEB output
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%% path set up
% script find all VASP files - including files within all the subflolders 
input_fldr = 'C:\Users\Gu\Desktop\Checking\2-16\New folder\';
convert_CONTCAR = 1;
convert_XDATCAR = 0;
convert_POSCAR = 0;
%%% if turned on, will print energy if OSZICAR is found
options.read_OSZICAR_and_include_energy_in_file_name = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
%%% Add the location of the matlab script as path
paths.mfile = [fileparts(which([mfilename '.m'])) '\'];
%%% Add functions to path
addpath([paths.mfile 'VASP_read_write_library\']);
addpath([paths.mfile 'etc_library\rdir\']);
addpath([paths.mfile 'etc_library\grep04apr06\']);

%% Convert
%%% CONTCAR first
if convert_CONTCAR
    flist = rdir([input_fldr '\**\CONTCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        VASPoutput_to_XSD_XTD(paths,options);      
    end
end

if convert_POSCAR
    flist = rdir([input_fldr '\**\POSCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        VASPoutput_to_XSD_XTD(paths,options);      
    end
end

if convert_XDATCAR
    flist = rdir([input_fldr '\**\XDATCAR']);
    for i=1:length(flist)
        paths.input = flist(i).name;
        VASPoutput_to_XSD_XTD(paths,options);      
    end
end

% % 
% % if Mode == 3;
%     d = dir(basefldr);
%     isub = [d(:).isdir];
%     nameFolds = {d(isub).name}';
%     nameFolds(ismember(nameFolds,{'.','..'})) = [];
%     Addtext(handles.statustext, 'Converting NEB images to xtd...')
%     for i = 1:length(nameFolds)
%         subfldr = [basefldr, char(nameFolds(i)), '\'];
%         outfldr = subfldr;
%         dd = dir(subfldr);
%         for j = 1:length(dd)
%             if strcmp(dd(j).name, 'CONTCAR') == 1
%                  flname = 'CONTCAR';
%                  break
%             elseif strcmp(dd(j).name, 'POSCAR') == 1
%                  flname = 'POSCAR';
%             end
%         end
%         XSDFileOut = [char(nameFolds(i)) '.xsd'];
%         [NAtoms,AtomElement,AtomPosition,n,AtomCur,AtomPos,Vec] = VASPConfigRead(subfldr,flname);
%         AtomPosImages(:,:,:,i) = AtomPos;
%     end
%     XTDFileWrite([basefldr XTDFileout '_NEB.xtd'],n,AtomCur,AtomPosImages,Vec,10);
% end



end


    
