function [BCP] = Outcritic_Read(fpath)
%% User Input
BCPTOL = 1E-3; %Tolerance for electron density for the critical point

%% Read brief BCP data 
%%% Move the line until the critical point listing
fid = fopen(fpath);
eofstat = false;
while ~eofstat
    textLine = fgetl(fid); eofstat = feof(fid);
        if ~isempty(strfind(textLine,'Critical point list'))
            break
        end
end
fgetl(fid); fgetl(fid); fgetl(fid); textLine = fgetl(fid);%Start of the Critical Point data

%%% Read bond critical point
NBCP = 0;
BCP = [];
while ~isempty(textLine)
    NBCP = NBCP + 1;
    StrWords = textscan(textLine,'%s');
    %In case of bond critical points
    if strcmp(StrWords{1}{5} ,'bond') && BCPTOL < str2double(StrWords{1}{11})
        BCP(end+1).i = NBCP; %#ok<AGROW>
        BCP(end).positions(1) = str2double(StrWords{1}{6});
        BCP(end).positions(2) = str2double(StrWords{1}{7});
        BCP(end).positions(3) = str2double(StrWords{1}{8});
        BCP(end).ED = str2double(StrWords{1}{11});
        BCP(end).LAP = str2double(StrWords{1}{13});
    end
    textLine = fgetl(fid);
end
%% Read detailed BCP data 
%%% Move the line until the critical point listing
while ~eofstat
    textLine = fgetl(fid); eofstat = feof(fid);
        if ~isempty(strfind(textLine,'* Additional properties at the critical points'))
            break
        end
end
fgetl(fid);
% below shows how many entries to skip between each BCP
diff_list = diff([0 BCP.i])-1;
for i=1:length(diff_list)
    % skip entries
    for j=1:diff_list(i)
        textline = fgetl(fid);
        if strcmp(textline,'  Type : (3, 1)'); fgetl(fid); end;
        fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);
        fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);
    end
    % read entry
    fgetl(fid); %type
    fgetl(fid); fgetl(fid); % ED
    fgetl(fid); fgetl(fid); % gradient
    fgetl(fid); fgetl(fid); % laplacian
    textline = fgetl(fid); % Hessian Eigenvalues;
    BCP(i).hes_eigen = sort(str2num(textline(23:end))); %#ok<AGROW,ST2NM>
    fgetl(fid); fgetl(fid); fgetl(fid); fgetl(fid); % Hessian
    fgetl(fid); fgetl(fid); % field and next entry
end
fclose(fid);

%% Post processing Surface
%%% compute ellipticity
for i=1:length(BCP)
    BCP(i).ellipticity = BCP(i).hes_eigen(1)/BCP(i).hes_eigen(2) -1; %#ok<AGROW>
end


end