function data = extractWeather(month, day, year)

global july_data august_data days years april_data

% year = 1980;
% month = 8;
% day = 27;

y_id = find(year == years);
d_id = find(day == days);

switch month
    case 7
        temp_data = july_data{d_id,y_id};
    case 8
        temp_data = august_data{d_id,y_id};
    case 4
        temp_data = april_data{d_id,y_id};
end

% Number of rows
br_ids = strfind(temp_data,'<br />');
n_entries = length(br_ids)-1;

% labels
temp_str = temp_data(1:br_ids(1)-1);
labels = textscan(temp_str,'%s','delimiter',',');
labels = labels{1};

data = cell(n_entries, length(labels));

for i = 1:n_entries
    temp_str = temp_data(br_ids(i)+6:br_ids(i+1)-1);
    a = textscan(temp_str,'%s','delimiter',',');
    a = a{1};
    if strcmp(a,'No daily or hourly history data available')
        continue
    end
    data{i,1} = datenum(a{1},16)-datenum(2012,1,1);  % Time of day
    data{i,2} = check_data_numeric(a{2});  % Temperature
    data{i,3} = check_data_numeric(a{3});  % Dew Point
    data{i,4} = check_data_numeric(a{4});  % Humidity
    data{i,5} = check_data_numeric(a{5});  % Sea Level Pressure
    data{i,6} = check_data_numeric(a{6});  % Visibility
    data{i,7} = a{7};  % Wind Direction
    data{i,8} = check_data_numeric(a{8});  % Wind Speed
    data{i,9} = check_data_numeric(a{9});  % Gust Speed
    data{i,10}= check_data_numeric(a{10}); % Precipitation
    data{i,11}= a{11}; % Events
    data{i,12}= a{12}; % Conditions
    data{i,13}= a{13}; % Wind Direction
    data{i,14}= a{14}; % Date
end

function outdata = check_data_numeric(indata)

if strcmp(indata,'-9999') || strcmp(indata,'N/A') 
   outdata = NaN; 
elseif strcmp(indata,'Calm') || strcmp(indata,'-')
    outdata = 0;
else
    outdata = str2double(indata);
end

    
    