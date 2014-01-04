function [wedding_data] = wedding_venues()

% Test San Francisco venues

% urls = {'http://www.herecomestheguide.com/northern-california/wedding-venues/region/san-francisco/62/';...
%     'http://www.herecomestheguide.com/northern-california/wedding-venues/region/san-francisco/62/P20/';...
%     'http://www.herecomestheguide.com/northern-california/wedding-venues/region/san-francisco/62/P40/';...
%     'http://www.herecomestheguide.com/northern-california/wedding-venues/region/san-francisco/62/P60/';...
%     'http://www.herecomestheguide.com/northern-california/wedding-venues/region/san-francisco/62/P80/'};

test = urlread('http://www.herecomestheguide.com/');

% Peninsula
urls = {'http://www.herecomestheguide.com/northern-california/wedding-venues/region/peninsula/65/P0';...
'http://www.herecomestheguide.com/northern-california/wedding-venues/region/peninsula/65/P20/';...
'http://www.herecomestheguide.com/northern-california/wedding-venues/region/peninsula/65/P40/'};


wedding_data = {};

for r = 1:length(urls)
    
    disp(['--------------- ',num2str(r),' of ',num2str(length(urls)),' ---------------'])
    
    data = urlread(urls{r});
    
    name_ids = strfind(data,'class="thumb-list" />');
    city_ids = strfind(data,'<td class="no-border">');
    url_ids = strfind(data,'<a href="');
    
    venues = cell(length(name_ids),9);
    
    
    for i = 1:length(name_ids)
        
        % Find the full venue name
        for j = 1:1000
            if strcmp(data(name_ids(i)+21+j),'<')
                j = j-1;
                break
            end
        end
        venues{i,1} = data((name_ids(i)+21)+(0:j));
        
        % Find the city of the venue
        temp_city_id = city_ids(find(city_ids > name_ids(i),1,'first'));
        
        for j = 1:1000
            if strcmp(data(temp_city_id+22+j),'<')
                j = j-1;
                break
            end
        end
        
        venues{i,2} = data(temp_city_id+22+(0:j));
        
        % Get the link to the venue
        temp_url_id = url_ids(find(url_ids < name_ids(i),1,'last'));
        
        for j = 1:1000
            if strcmp(data(temp_url_id+9+j),'>')
                j = j-2;
                break
            end
        end
        
        venues{i,3} = ['http://www.herecomestheguide.com',data(temp_url_id+9+(0:j))];
        
%         % Extract the information from the venue-specific link
%         
%         disp([num2str(i),' of ',num2str(length(name_ids)),' - Reading data for venue: ',venues{i,1}])
%         
%         venue_data = urlread(venues{i,3});
%         br_ids = strfind(venue_data,'<br />');
%         p_ids = strfind(venue_data,'<p>');
%         pend_ids = strfind(venue_data,'</p>');
%         
%         % Maximum reception indoor seating
%         id = strfind(venue_data,'Max. Seated Indoors:');
%         venues{i,4} = venue_data(id(2)+21 : (br_ids(find(br_ids > id(2),1,'first')))-1);
%         
%         % Maximum reception outdoor seating
%         id = strfind(venue_data,'Max. Seated Outdoors:');
%         venues{i,5} = venue_data(id(2)+22 : (br_ids(find(br_ids > id(2),1,'first')))-1);
%         
%         % Fees and Deposit information
%         id = strfind(venue_data,'<h3>Fees &amp; Deposits</h3>');
%         venues{i,6} = venue_data(p_ids(find(p_ids > id,1,'first'))+3:pend_ids(find(pend_ids > id,1,'first'))-1);
%         
%         % Catering
%         try
%             id = strfind(venue_data,'<h3>Catering</h3>');
%             id_next = strfind(venue_data,'<h3>');
%             id_next = id_next(find(id_next > id,1,'first'));
%             
%             venues{i,7} = venue_data(id+17:id_next-1);
%             venues{i,7} = remove_trailing_spaces(strrep(venues{i,7},'<br />',' OR '));
%         catch
%             disp(['Error finding catering info'])
%         end
%         
%         
%         % Alcohol
%         try
%             id = strfind(venue_data,'<h3>Alcohol</h3>');
%             id_next = strfind(venue_data,'<h3>');
%             id_next = id_next(find(id_next > id,1,'first'));
%             
%             venues{i,8} = venue_data(id+16:id_next-1);
%             venues{i,8} = remove_trailing_spaces(strrep(venues{i,8},'<br />',' OR '));
%         catch
%             disp(['Error finding alcohol info'])
%         end
%         
%         % Venue Type
%         try
%             id = strfind(venue_data,'<h3>Venue Type</h3>');
%             id_next = strfind(venue_data,'<h3>');
%             id_next = id_next(find(id_next > id,1,'first'));
%             
%             venues{i,9} = venue_data(id+19:id_next-1);
%             venues{i,9} = remove_trailing_spaces(strrep(venues{i,9},'<br />',', '));
%             
%         catch
%             disp(['Error finding venue type'])
%         end
%         
    end
    
    wedding_data = [wedding_data; venues];
    
end

a = 1;


function out_string = remove_trailing_spaces(in_string)

for j = length(in_string):-1:1
    if ~strcmp(in_string,' ')
        break
    end
end

out_string = in_string(1:j);

