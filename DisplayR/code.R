
## From ...
## https://www.displayr.com/pure-html/?utm_medium=Feed&amp;utm_source=Syndication
## ... slightly tweaked for font specification (removed 'font-family: arial;')

my.data = matrix(1:9, nrow = 3,
                 dimnames = list(c("This is a long column heading; too long to show neatly in any of of the visualization packages that I know and love", "This is a second column heading; too long to show neatly in any of of the visualization packages that I know and love.", "This is a third  column heading; too long to show neatly in any of of the visualization packages that I know and love."),
                                 c("This was a long row heading; too long to show neatly in any of of the visualization packages that I know and love", "This is another long column heading, which is too long to show neatly in any of of the visualization packages that I know and love", "This is a third long column heading, which is too long to show neatly in any of of the visualization packages that I know and love")))

MyHeatmap <- function(x)
{ 
    # Lookups for coloring cells and fonts
    require(RColorBrewer)
    cell.colors = colorRampPalette(brewer.pal(9,"Blues"))(101)
    font.colors = c(rep("blue", 60), rep("white", 41))

    # Scaling the data to be on [1, 2, ..., 101], for the lookups
    min.x <- min(x)
    max.x <- max(x)
    scaled.x = round((x - min(x)) / (max(x) - min(x)) * 100, 0) + 1

    # Writing the cells styles
    n.rows = nrow(x)
    n.columns = ncol(x)
    rows = rep(1:n.rows, rep(n.columns, n.rows))
    columns = rep(1:n.columns, n.rows)
    x.lookups = as.numeric(t(scaled.x))
    cells.styles = paste0('td.cell', rows, columns, ' {background-color: ',
                          cell.colors[x.lookups], '; color: ',
                          font.colors[x.lookups] ,';}')
    cell.styles = paste0(cells.styles, collapse = "\n")
    
    # Creating the table
    columns.headers = paste0('<th>', c("", dimnames(x)[[2]]) ,'</th>')
    tble = paste0(columns.headers, collapse = "\n")
    row.headers = paste0('<th>', c(dimnames(x)[[1]]) ,'</th>')
    for (row in 1:n.rows)
    {
        row.cells = paste0('<td class = "border cell', row, 1:n.columns,
                           '">', x[row,],'</td>')
        tble = paste0(tble, '<tr>', row.headers[row],
                      paste(row.cells, collapse = '\n'), '</tr>')
    }
    # Assembling the HTML
    html = paste0('<!DOCTYPE html>
    <html>
    <head>
    <style>
      table, th, td {border-collapse: collapse; }
      th, td {padding: 5px; text-align: center; font-size: 8pt}
      td.border {border: 1px solid grey; }',' td.cell11 {background-color: #F7FBFF; color: blue;}',
      cell.styles, '
    </style>
    </head>
    <body>
    <table style="width:100%">', tble, '
    </table>
    </body>
    </html>')
    html
}

writeLines(MyHeatmap(my.data), "displayr.html")

## MyHeatmap(matrix(1:200, 
##                  nrow = 20, 
##                  dimname = list(LETTERS[1:20], 
##                                 letters[1:10])))
