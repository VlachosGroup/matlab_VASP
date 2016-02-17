function POSCAR_Write(flname,mol_data)
%%  Code written by Geun Ho Gu
%   University of Delaware
%   December 30th, 2015
newline = char(10);
fidout = fopen(flname,'w');
slash_index = regexp(flname,'\');
name = flname(slash_index(end-1)+1:slash_index(end)-1);
fprintf(fidout,[name newline]);
fprintf(fidout,['    1.00000000' newline]);

for j = 1:3
    s1 = num2str(mol_data.cell(j,1),'%22.16f'); n1 = 22-length(s1);
    s2 = num2str(mol_data.cell(j,2),'%22.16f'); n2 = 22-length(s2);
    s3 = num2str(mol_data.cell(j,3),'%22.16f'); n3 = 22-length(s3);
    fprintf(fidout,[' ' repmat(' ',1,n1) s1 repmat(' ',1,n2) s2 repmat(' ',1,n3) s3 newline]);
end
for i = 1:length(mol_data.unique_elements)
    fprintf(fidout,['  ' mol_data.unique_elements{i}]);
end
fprintf(fidout,newline);
for i = 1:length(mol_data.unique_elements)
    fprintf(fidout,['  ' num2str(nnz(strcmp(mol_data.unique_elements{i},mol_data.chemical_symbols)))]);
end
fprintf(fidout,newline);
fprintf(fidout,['Selective dynamics' newline 'Direct' newline]);
for i = 1:size(mol_data.positions,1)
    s1 = num2str(mol_data.positions(i,1),'%20.16f'); n1 = 20-length(s1);
    s2 = num2str(mol_data.positions(i,2),'%20.16f'); n2 = 20-length(s2);
    s3 = num2str(mol_data.positions(i,3),'%20.16f'); n3 = 20-length(s3);
    if mol_data.freeze(i) == 1;
        FreeToMove = 'F';
    else
        FreeToMove = 'T';
    end
    fprintf(fidout,[repmat(' ',1,n1) s1 repmat(' ',1,n2) s2 repmat(' ',1,n3) s3 ...
        '  ' FreeToMove '  ' FreeToMove '  ' FreeToMove '  ' newline]);
end

fclose(fidout);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end