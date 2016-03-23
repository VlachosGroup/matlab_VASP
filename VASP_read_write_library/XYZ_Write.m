function XYZ_Write(flpath, AtomList, PosMat, varargin)
newlinechar = char(10);
fidout = fopen(flpath,'w');
fprintf(fidout, [num2str(length(AtomList)) newlinechar]);
if nargin == 4
    fprintf(fidout, [varargin{1} newlinechar]);
elseif nargin == 3
    fprintf(fidout, ['converted from VASP' newlinechar]);
end
PosMat = round(PosMat,4);
for i=1:length(AtomList)
    fprintf(fidout, [AtomList{i} '   ' num2str(PosMat(i,1)) '   ' num2str(PosMat(i,2)) '   ' num2str(PosMat(i,3)) newlinechar]);
end
fprintf(fidout, newlinechar);
fclose(fidout);