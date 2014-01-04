function [wedding_data] = wedding_venue_process2()

load('venue_data.mat');

% field_names = {'sf','peninsula','eastbay','napa','northbay','southbay'};
field_names = {'peninsula'};

for r = 1:length(field_names)
    
    urls = eval(['venues.',field_names{r}]);
    
    n_venues = length(urls);
    
    venue_data = cell(n_venues,10);
    
    %     1.  Name
    %     2.  Region
    %     3.  City
    %     4.  Link
    %     5.  Max indoor seating
    %     6.  Max outdoor seating
    %     7.  Fees and Deposits
    %     8.  Catering
    %     9.  Alcohol
    %     10. Venue Type
    
    
    for k = 1:n_venues
        
        data = urlread(urls{k});
        
        % General useful characters
        br_ids = strfind(data,'<br />');
        p_ids = strfind(data,'<p>');
        pend_ids = strfind(data,'</p>');
        
        % Get the name of the venue
        try
            idx1 = strfind(data,'<h1>');
            idx2 = strfind(data,'</h1>');
            venue_data{k,1} = remove_trailing_spaces(data(idx1+4:idx2-1));  % not sure about the spaces
            disp([num2str(k),' of ',num2str(n_venues),' in ',field_names{r},': ',venue_data{k,1}])
        catch
            disp('Error finding name of venue')
        end
        
        % Region is specified by the field name
        venue_data{k,2} = field_names{r};
        
        % City
        try
            contact_id = strfind(data,'<div class="contactBox1">');
            loc_brs = find(br_ids > contact_id);
            venue_data{k,3} = remove_trailing_spaces(data(br_ids(loc_brs(2))+6:br_ids(loc_brs(3))-1));
        catch
            disp('Error finding city information')
        end
        % Max indoor seating
        try
            id = strfind(data,'Max. Seated Indoors:');
            venue_data{k,5} = data(id(2)+21 : (br_ids(find(br_ids > id(2),1,'first')))-1);
        catch
            disp('Error finding max indoor seating info')
        end
        % Maximum reception outdoor seating
        try
            id = strfind(data,'Max. Seated Outdoors:');
            venue_data{k,6} = data(id(2)+22 : (br_ids(find(br_ids > id(2),1,'first')))-1);
        catch
            disp('Error finding max outdoor seating info')
        end
        % Fees and Deposit information
        try
            id = strfind(data,'<h3>Fees &amp; Deposits</h3>');
            venue_data{k,7} = remove_trailing_spaces(strrep(data(p_ids(find(p_ids > id,1,'first'))+3:pend_ids(find(pend_ids > id,1,'first'))-1),'<br />',';'));
        catch
            disp('Error finding fee information')
        end
        % Catering
        try
            id = strfind(data,'<h3>Catering</h3>');
            id_next = strfind(data,'<h3>');
            id_next = id_next(find(id_next > id,1,'first'));
            
            venue_data{k,8} = data(id+17:id_next-1);
            venue_data{k,8} = remove_trailing_spaces(strrep(venue_data{k,8},'<br />',' OR '));
        catch
            disp(['Error finding catering info'])
        end
        
        
        % Alcohol
        try
            id = strfind(data,'<h3>Alcohol</h3>');
            id_next = strfind(data,'<h3>');
            id_next = id_next(find(id_next > id,1,'first'));
            
            venue_data{k,9} = data(id+16:id_next-1);
            venue_data{k,9} = remove_trailing_spaces(strrep(venue_data{k,9},'<br />',' OR '));
        catch
            disp(['Error finding alcohol info'])
        end
        
        % Venue Type
        try
            id = strfind(data,'<h3>Venue Type</h3>');
            id_next = strfind(data,'<h3>');
            id_next = id_next(find(id_next > id,1,'first'));
            
            venue_data{k,10} = data(id+19:id_next-1);
            venue_data{k,10} = remove_trailing_spaces(strrep(venue_data{k,10},'<br />',', '));
            
        catch
            disp(['Error finding venue type'])
        end
        
        a =1;
        
    end
    
    eval(['wedding_data.',field_names{r},'=venue_data']);
    
end




function out_string = remove_trailing_spaces(in_string)

nchar = isstrprop(in_string,'alpha') | isstrprop(in_string,'alphanum');

start_idx = find(nchar == 1,1,'first');
stop_idx = find(nchar == 1,1,'last');

out_string = in_string(start_idx:stop_idx);
%
% for j = length(in_string):-1:1
%     if ~strcmp(in_string,' ')
%         break
%     end
% end
%
% out_string = in_string(1:j);

