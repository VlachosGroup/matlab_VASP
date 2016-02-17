%% Function to write an INCAR file
function KPOINTS_Write(outfldr,kpoints)
newline = char(10);
fidout = fopen([outfldr 'KPOINTS'],'w');
fprintf(fidout,['K-Point Grid. Created on ' date '.' newline]);
fprintf(fidout,['0' newline]);
fprintf(fidout,['Monkhorst-Pack' newline]);
fprintf(fidout,[num2str(kpoints(1)) ' ' num2str(kpoints(2)) ' ' num2str(kpoints(3)) newline]);
fprintf(fidout,['0. 0. 0.' newline]);
fclose(fidout);


end