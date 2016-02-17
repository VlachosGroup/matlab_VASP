% 11/20/2015 Geun Ho Gu. University of Delaware
% Read vibrational frequency (in cm-1)
% Need GREP function.
% Code doesn't work yet
function Vib = OUTCAR_Vib_Freq_Vec_Read(flpath) %[VibFreqs,VibEvecs] = VASPOutputVibModesParse(basefldr,flname)
if ~exist(flpath,'file'); VibVec = -1;return;end
% Need grep function. Add path if grep is missing
if exist('grep.m','file')
    mfile_path = [fileparts(which([mfilename '.m'])) '\'];
    slash_index = regexp(mfile_path,'\');
    addpath([mfile_path(1:slash_index(end-1)) 'etc_library\grep04apr06\']);
end
%% Initialization/User specified value
%%% Search pattern
% Regular vibrational frequency search pattern and index of where the frequency is written in cm-1
searchstr1 = ' f  ='; iwrd12 = 8;
% For imaginary frequency
searchstr2 = ' f/i='; iwrd22 = 7;

%% Grep the vibrational frequnecies
[~, P] = grep('-Q -s', 'cm-1', flpath);

%% check if the file exist
if P.nfiles == 0; VibVec = -1;return;end

%% Read Vibrations
VibVec = zeros(P.lcount,1);
for i=1:P.lcount
    textLine = P.match{i};
    if ~isempty(strfind(textLine,searchstr1))
        StrWords = textscan(textLine,'%s');
        VibVec(i) = str2double(StrWords{1}{iwrd12});
    elseif ~isempty(strfind(textLine,searchstr2))
        StrWords = textscan(textLine,'%s');
        VibVec(i) = str2double(StrWords{1}{iwrd22})*1i;
    end
end
end