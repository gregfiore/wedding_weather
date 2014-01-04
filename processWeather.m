
months = [4];
days = 1:30;
years = 1980:2011;

july_data = cell(length(days),length(years));
august_data = cell(length(days),length(years));

preamble = 'http://www.wunderground.com/history/airport/KSTS/';
postscript = '/DailyHistory.html?req_city=Sebastopol&req_state=CA&req_statename=California&format=1';

% Do the april data first
for i = 1:length(years)
    for j = 1:30
        date_str = [num2str(years(i)),'/4/',num2str(j)];
        disp(['Processing ',date_str]);
        april_data{j, i}  = urlread([preamble,date_str,postscript]);
    end
end

% % Do the july data first
% for i = 1:length(years)
%     for j = 1:length(days)
%         date_str = [num2str(years(i)),'/7/',num2str(j)];
%         disp(['Processing ',date_str]);
%         july_data{j, i}  = urlread([preamble,date_str,postscript]);
%     end
% end
% 
% % Do the august data 
% for i = 1:length(years)
%     for j = 1:length(days)
%         date_str = [num2str(years(i)),'/8/',num2str(j)];
%         disp(['Processing ',date_str]);
%         august_data{j, i}  = urlread([preamble,date_str,postscript]);
%     end
% end                
%             
%         
% a = 1;    
% 
