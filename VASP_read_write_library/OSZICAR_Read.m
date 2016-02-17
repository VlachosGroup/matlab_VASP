function [E]=OSZICAR_Read(paths)
% Need grep function. Add path if grep is missing
if exist('grep.m','file')
    mfile_path = [fileparts(which([mfilename '.m'])) '\'];
    slash_index = regexp(mfile_path,'\');
    addpath([mfile_path(1:slash_index(end-1)) 'etc_library\grep04apr06\']);
end
% addpath('..\etc_library\grep04apr06\'); % addpath eats up cpu so do this 
% in the main script
% grep two line important line
[~, P] = grep('-Q -s', {'F=', 'RMM'}, paths);
textLine = P.match{P.lcount(1)};
StrWords = textscan(textLine,'%s');
E.total = str2double(StrWords{1}{5});
textLine = P.match{P.lcount(1)+P.lcount(2)};
StrWords = textscan(textLine,'%s');
E.elec = str2double(StrWords{1}{3});
E.disp = E.total - E.elec;
end
