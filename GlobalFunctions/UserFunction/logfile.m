function logfile(ME)
t = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
DateString = datestr(t);
fid = fopen(fullfile(pwd,'logFile'),'a+');
fprintf(fid,'-----------------------');
fprintf(fid,'%s', DateString);
fprintf(fid,'-----------------------\n');
fprintf(fid,'%s', ME.getReport('extended','hyperlinks','off'));
fprintf(fid,'\n\n');

% close file
fclose(fid);
