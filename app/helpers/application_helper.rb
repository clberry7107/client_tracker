module ApplicationHelper
    
    def sortable(column, title=nil)
        title ||= column.titleize
        direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
        if column != "ListName"
            second_sort = ", ListName asc"
        end
        link_to title, :sort => column, :direction => direction, :secondary => second_sort
    end
    

end
