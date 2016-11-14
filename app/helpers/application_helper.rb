module ApplicationHelper
    shops = ["Clevend", "Los Angeles", "London", "Sydney"]
    def sortable(column, title=nil)
        title ||= column.titleize
        direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
        if column != "ListName"
            second_sort = ", ListName  asc"
        end
        link_to title, :sort => column, :direction => direction, :secondary => second_sort
    end
    
    def near_shop(cities)
        markers = Array.new
        cities.each do |city|
            markers << shop_marker(city.Region)
        end
        markers.uniq!
        markers.reject!{|item| item.empty?}
        marks = ""
        markers.each do |mark|
            marks << mark
        end
        return marks
    end
    
    def shop_marker(region)
        add = ""
        case region
        when "Cleveland, OH"
            add << "*"
        when "Los Angeles, CA"
            add << "<"
        when "London, United Kingdom"
           add << "~"
        when "Sydney, Austrailia"
            add << "v"
        end
           
        return add   
    end

end
