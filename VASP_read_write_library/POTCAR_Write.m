function POTCAR_Write(potenfldr,outfldr,element)
% Written by Geun Ho Gu 30-Dec-2015. University of Delaware.
% Write POTCAR
%% use system command to concatenate files. Knows windows and unix, need more writing for mac.
if ispc
    command = 'copy ';
    for i = 1:length(element)
        command = [command '"' potenfldr element{i} '\POTCAR"+']; %#ok<AGROW>
    end
    command = [command(1:end-1) ' "' outfldr 'POTCAR"'];
    [~,~] = system(command);
elseif isunix
    command = 'cat ';
    for i = 1:length(element)
        command = [command potenfldr element{i} '\POTCAR ']; %#ok<AGROW>
    end
    command = [command(1:end) '> ' outfldr 'POTCAR'];
    [~,~] = system(command);
    
end

end