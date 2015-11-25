module ApplicationHelper
    
    def sortable(column, title=nil)
        title ||= column.titleize
        direction = column == sort_column && sort_direction == "ASC" ? "DESC" : "ASC"
        if column != "ListName"
            second_sort = ", ListName: :ASC"
        end
        link_to title, :sort => column, :direction => direction, :secondary => second_sort
    end
end
