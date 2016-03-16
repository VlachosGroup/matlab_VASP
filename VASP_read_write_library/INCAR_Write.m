%% Function to write an INCAR file
function INCAR_Write(outfldr,param)
%written by Geun Ho Gu
slash_index = regexp(outfldr,'\');
name = outfldr(slash_index(end-1)+1:end-1);
fields = fieldnames(param);
fidout = fopen([outfldr 'INCAR'],'w');
newline = char(10);
fprintf(fidout,['INCAR file from ' name '. Created by ' param.author ' on ' date '.' newline]);
fprintf(fidout,['# Please see VASP manual for explanations of each parameters' newline]);
fprintf(fidout,[ newline '# Output Options' newline]);
fields1 = {'NWRITE', 'LWAVE', 'LCHARG', 'LVTOT'};
for i=1:length(fields1)
    match = strcmp(fields1{i},fields);
    if any(match)
        spacing = repmat(' ',[1,12-length(fields1{i})]);
        fprintf(fidout, [fields1{i} spacing '= ' num2str(param.(fields{match})) newline]);
    end
end

fprintf(fidout,[newline '# Functional Choice' newline]);
fields2 = {'LVDW', 'VDW_VERSION', 'GGA'};
for i=1:length(fields2)
    match = strcmp(fields2{i},fields);
    if any(match)
        spacing = repmat(' ',[1,12-length(fields2{i})]);
        fprintf(fidout, [fields2{i} spacing '= ' num2str(param.(fields{match})) newline]);
    end
end

fprintf(fidout,[newline '# Electronic Relaxation' newline]);
fields3 = {'ENCUT', 'ALGO', 'ISMEAR', 'SIGMA', 'VOSKOWN', 'PREC', 'ROPT', 'ISTART', 'NELM', 'NELMDL', 'EDIFF', 'ISYM', 'ISPIN','ICHARG','MAGMOM'};
for i=1:length(fields3)
    match = strcmp(fields3{i},fields);
    if any(match)
        spacing = repmat(' ',[1,12-length(fields3{i})]);
        fprintf(fidout, [fields3{i} spacing '= ' num2str(param.(fields{match})) newline]);
    end
end

fprintf(fidout,[newline '# Optimizer Options' newline]);
fields4 = {'NSW','ISIF','IBRION','NFREE','POTIM','EDIFFG','LCLIMB','ICHAIN','IMAGES','SPRING'};
for i=1:length(fields4)
    match = strcmp(fields4{i},fields);
    if any(match)
        spacing = repmat(' ',[1,12-length(fields4{i})]);
        fprintf(fidout, [fields4{i} spacing '= ' num2str(param.(fields{match})) newline]);
    end
end

fprintf(fidout,[newline '# Parallelization' newline]);
fields5 = {'NPAR','LPLANE'};
for i=1:length(fields5)
    match = strcmp(fields5{i},fields);
    if any(match)
        spacing = repmat(' ',[1,12-length(fields5{i})]);
        fprintf(fidout, [fields5{i} spacing '= ' num2str(param.(fields{match})) newline]);
    end
end

fprintf(fidout,[newline '# ETC' newline]);
all_fields = [fields1 fields2 fields3 fields4 fields5 'author'];
for i=1:length(fields)
    match = strcmp(fields{i},all_fields);
    if ~any(match)
        spacing = repmat(' ',[1,12-length(fields{i})]);
        fprintf(fidout, [fields{i} spacing '= ' num2str(param.(fields{i})) newline]);
    end
end
fclose(fidout);

return;
end