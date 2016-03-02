#' @importFrom htmltools tag
html_table <- function(x, align = "left" , caption = NULL) {
  row_counter <- 0L
  tag("table", list(
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
      tag("tr", c(class = if (row_counter %% 2L == 0L) "even" else "odd",
        .mapply(function(align, value) {
          tag("td", list(align = align, value))
        }, list(align, cells), NULL)))
    }, x, NULL))
  ))
}
