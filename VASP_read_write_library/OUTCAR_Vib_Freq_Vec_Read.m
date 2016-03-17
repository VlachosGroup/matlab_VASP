% 3/17/2015 Geun Ho Gu. University of Delaware
% Read vibrational frequency (in cm-1) and eigen vector. Eignvector is
% given in absolute coordinate
% Input:
%   OUTCAR_Vib_Freq_Vec_Read(flpath,read_vec)
%       flpath = path of OUTCAR
%       read_vec = 0/1. use 1 to read eigenvectors; 2 to read only the
%       imaginary
% OUTPUT:
%       Vib.freqs = vibrational frequencies
%       Vib.evecs = vibrational eigenvectors given in cartesian coordinate
function [Vib] = OUTCAR_Vib_Freq_Vec_Read(flpath,varargin)
if ~exist(flpath,'file'); Vib = -1;return;end
if nargin ==1
    read_vec =0;
elseif nargin == 2
    read_vec = varargin{1};
else
    error('too many arguments')
end
%% Initialization/User specified value
%%% Search pattern
% Regular vibrational frequency search pattern and index of where the frequency is written in cm-1
searchstr1 = ' f  ='; iwrd12 = 8;
% For imaginary frequency
searchstr2 = ' f/i='; iwrd22 = 7;
%% set_up pattern finding. based on grep function
fid = fopen(flpath);
s = fread(fid,Inf,'*char').';               % Read in binary format for speed.
cr = sprintf('\r');                         % carriage return
lf = sprintf('\n');                         % line flag
if ispc; s = strrep(s,[cr,lf],lf); end      % clean up line marker
s=strrep(s,char(0),'^');                    % Not clear what this does
eol = [0,strfind(s,lf),numel(s)+1];         % end of line marker(s)

%% search
% find the beginning of vib result
ix=strfind(s,'THz');
[~,lx]=histc(ix,eol); 
lx=lx(find([diff(lx),1])); %#ok<FNDSB>      % Do what unique does, but 20x faster
%% Record frequencies
nf = length(lx);
Vib(nf) = struct('freqs',[]);
for i=1:length(lx)
    textLine = s(eol(lx(i)):eol(lx(i)+1));
    if ~isempty(strfind(textLine,searchstr1))
        StrWords = textscan(textLine,'%s');
        Vib(i).freqs = str2double(StrWords{1}{iwrd12});
    elseif ~isempty(strfind(textLine,searchstr2))
        StrWords = textscan(textLine,'%s');
        Vib(i).freqs = str2double(StrWords{1}{iwrd22})*1i;
    end
end
%% Read vectors
if read_vec == 1;
na=lx(2)-lx(1)-3;   % determine number of atom
for i=1:length(lx)
    for j=1:na
        textline=s(eol(lx(i)+1+j):eol(lx(i)+2+j));
%         evec = str2num(textline);     % slower
%         Vib(i).evecs(j,:) = evec(4:6);    % slower
        Vib(i).evecs(j,:) = cell2mat(textscan(textline,'%*f %*f %*f %f %f %f'));
    end
end
elseif read_vec == 2;
na=lx(2)-lx(1)-3;   % determine number of atom
for i=1:length(lx)
    if ~isreal(Vib(i).freqs)
        for j=1:na
            textline=s(eol(lx(i)+1+j):eol(lx(i)+2+j));
            Vib(i).evecs(j,:) = cell2mat(textscan(textline,'%*f %*f %*f %f %f %f'));
        end
    end
end
end
end