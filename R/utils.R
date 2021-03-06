dropNULL = function(x) {
  if (length(x) == 0 || !is.list(x)) return(x)
  x[!unlist(lapply(x, is.null))]
}

isFALSE = function(x) identical(x, FALSE)

is.Date = function(x) inherits(x, c('Date', 'POSIXlt', 'POSIXct'))

# for CSS propertices: fontWeight -> font-weight, backgroundColor ->
# background-color, etc
upperToDash = function(x) {
  x = gsub('^(.)', '\\L\\1', x, perl = TRUE)
  x = gsub('([A-Z])', '-\\L\\1', x, perl = TRUE)
  x
}

# not rigorous, but should work in most cases
inShiny = function() 'shiny' %in% loadedNamespaces()

in_dir = function(dir, expr) {
  owd = setwd(dir); on.exit(setwd(owd))
  expr
}

existing_files = function(x) x[file.exists(x)]

# generate <caption></caption>
captionString = function(caption) {
  if (is.character(caption)) caption = tags$caption(caption)
  caption = as.character(caption)
  if (length(caption)) caption
}

toJSON = function(...) {
  FUN = getFromNamespace('toJSON', 'htmlwidgets')
  FUN(...)
}

# coerce a value to the same type as an old value
coerceValue = function(val, old) {
  if (is.integer(old)) return(as.integer(val))
  if (is.numeric(old)) return(as.numeric(val))
  if (inherits(old, 'Date')) return(as.Date(val))
  if (inherits(old, c('POSIXlt', 'POSIXct'))) {
    val = strptime(val, '%Y-%m-%dT%H:%M:%SZ', tz = 'UTC')
    if (inherits(old, 'POSIXlt')) return(val)
    return(as.POSIXct(val))
  }
  if (is.factor(old)) {
    if (val %in% levels(old)) return(val)
    warning(
      'New value ', val, ' not in the original factor levels: ',
      paste(levels(old), collapse = ', ')
    )
    return(NA)
  }
  val
}
