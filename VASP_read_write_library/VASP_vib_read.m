% 3/17/2015 Geun Ho Gu. University of Delaware
% Read vibrational frequency (in cm-1) and eigenvectors.
% Input:
%       flpath = path of VASP output folder containing CONTCAR and OUTCAR
%       read_vec = 0/1. use 1 to read eigenvectors
% OUTPUT:
%       Vib.freqs = vibrational frequencies
%       Vib.evecs = vibrational eigenvectors given in cartesian coordinate
function VASP_vib_read(fldrpath,option)
%% options
nframe = 20; % number of frame
amp = 0.3;   % amplitude of the animation
%% Read vibrational analysis
switch option
    case 2
        [Vib] = OUTCAR_Vib_Freq_Vec_Read([fldrpath 'OUTCAR'],1);
    case 3
        [Vib] = OUTCAR_Vib_Freq_Vec_Read([fldrpath 'OUTCAR'],2);
end
%% Print frequencies
slash_index = regexp(fldrpath,'\');
name = fldrpath(slash_index(end-1)+1:slash_index(end)-1);
fprintf('%s',name);
for j=1:length(Vib)
    if isreal(Vib(j).freqs)
        fprintf('\t%4.2f',Vib(j).freqs);
    else
        fprintf('\t%4.2fi',imag(Vib(j).freqs));
    end
end
fprintf('\n');
%% Make animations
[mol_data] = VASP_Config_Read([fldrpath 'CONTCAR']);
original_positions = mol_data.positions;
mol_data.positions = zeros(nframe,size(mol_data.positions,1),3);
for i=1:length(Vib)
    if ~isempty(Vib(i).evecs)
        for iframe = 1:nframe
            FracDispl = (Vib(i).evecs*amp*sin(2*pi*(iframe-1)/(nframe-1)))/mol_data.cell;
            mol_data.positions(iframe,:,:) = original_positions +FracDispl;
        end
        XTD_Write([fldrpath sprintf('%s_v%d.xtd',name,i)],mol_data,10)
    end
end
end