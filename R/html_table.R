#' @importFrom htmltools tag
html_table <- function(x, align = "left", caption = NULL,
  table_class = NULL, row_class = c("odd", "even")) {
  row_counter <- -1L
  tag("table", list(
    class = table_class,
    if (is.null(caption) || is.na(caption)) NULL
    else tag("caption", list(caption)),
    tag("thead", list(
      tag("tr", c(class = "header",
        .mapply(function(column, align) {
          tag("th", list(align = align, column))
        }, list(colnames(x), align), NULL)))
    )),
    tag("tbody", .mapply(function(...) {
      row_counter <<- row_counter + 1L
      cells <- unname(list(...))
      tag("tr", c(class = row_class[row_counter %% length(row_class) + 1L],
        .mapply(function(align, value) {
          tag("td", list(align = align, value))
        }, list(align, cells), NULL)))
    }, x, NULL))
  ))
}
