function [BCP] = Outcritic_Read(fpath)
%% User Input
BCPTOL = 1E-3; %Tolerance for electron density for the critical point
% BCPTOL = 0;

%% set_up pattern finding. based on grep function
fid = fopen(fpath);
s = fread(fid,Inf,'*char').';               % Read in binary format for speed.
fclose(fid);
cr = sprintf('\r');                         % carriage return
lf = sprintf('\n');                         % line flag
if ispc; s = strrep(s,[cr,lf],lf); end      % clean up line marker
s=strrep(s,char(0),'^');                    % Not clear what this does
eol = [0,strfind(s,lf),numel(s)+1];         % end of line marker(s)
%% search for brief list
% find the beginning of BCP list
ix=strfind(s,'* Critical point list');
[~,lx]=histc(ix,eol); 
lx=lx(find([diff(lx),1])); %#ok<FNDSB>      % Do what unique does, but 20x faster
% skip line
lx = lx + 4;
% record and filter BCPs
NBCP = 0;
BCP = [];
textLine = s(eol(lx):eol(lx+1));
while ~strcmp(textLine,sprintf('\n\n'))
    NBCP = NBCP + 1;
    % new critic2 version
%     if strcmp(strtrim(textLine(20:26)),'bond') && BCPTOL < str2double(textLine(83:98))
%         BCP(end+1).i = NBCP;
%         BCP(end).positions(1) = str2double(textLine(30:40));
%         BCP(end).positions(2) = str2double(textLine(43:53));
%         BCP(end).positions(3) = str2double(textLine(56:66));
%         BCP(end).ED = str2double(textLine(83:98));
%         BCP(end).LAP = str2double(textLine(115:130));
%     end
    % old critic2 version
    if strcmp(strtrim(textLine(19:26)),'bond') && BCPTOL < str2double(textLine(86:98))
        BCP(end+1).i = NBCP;
        BCP(end).positions(1) = str2double(textLine(32:42));
        BCP(end).positions(2) = str2double(textLine(44:54));
        BCP(end).positions(3) = str2double(textLine(56:66));
        BCP(end).ED = str2double(textLine(86:98));
        BCP(end).LAP = str2double(textLine(114:126));
    end
    lx = lx + 1;
    textLine = s(eol(lx):eol(lx+1));
end
%% Read detailed BCP data 
% find detailed BCP data
ix=strfind(s,'+ Critical point');
[~,lx]=histc(ix,eol); 
lx=lx(find([diff(lx),1])); %#ok<FNDSB>      % Do what unique does, but 20x faster
% record
for i=1:length(BCP)
    % trim string
    if length(lx) < BCP(i).i+1
        text = s(eol(lx(BCP(i).i)):end);
    else
        text = s(eol(lx(BCP(i).i)):eol(lx(BCP(i).i+1)));
    end
    eeol = [0,strfind(text,lf),numel(text)+1];         % end of line marker(s)
    % search 
    ix=strfind(text,'  Hessian eigenvalues:');
    [~,llx]=histc(ix,eeol);
    llx=llx(find([diff(llx),1])); %#ok<FNDSB>      % Do what unique does, but 20x faster
    BCP(i).hes_eigen = sort(str2num(text(eeol(llx)+24:eeol(llx+1)))); %#ok<AGROW,ST2NM>
    BCP(i).ellipticity = BCP(i).hes_eigen(1)/BCP(i).hes_eigen(2) -1; %#ok<AGROW>
end


end