jQuery ->
  $('#search').keyup (e) ->
    searchTable($(this).val())
  
  $('#search').keypress (e) ->
    if e.keycode == 13
      e.preventDefault()
      
  searchTable = (inputVal) ->
    regExp = new RegExp(inputVal, 'i')
    table = $('.search_table')
    table.find('tr').each (index, row) ->
      if index != 0
        allCells = $(row).find('td')
        if(allCells.length > 0)
          found = false
          allCells.each (index, td) ->
            if(regExp.test($(td).text()))
              found = true;
              return false;
          if(found == true)
            $(row).fadeIn()
          else
            $(row).fadeOut()