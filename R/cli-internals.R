
#' @importFrom fansi strwrap_ctl

cli__xtext <- function(self, private, ..., .envir, indent) {
  style <- private$get_style()$main
  text <- private$inline(..., .envir = .envir)
  text <- strwrap_ctl(text, width = private$get_width())
  if (!is.null(style$fmt)) text <- style$fmt(text)
  private$cat_ln(text, indent = indent)
  invisible(self)
}

cli__get_width <- function(self, private) {
  style <- private$get_style()$main
  left <- style$`margin-left` %||% 0
  right <- style$`margin-right` %||% 0
  console_width() - left - right
}

cli__cat <- function(self, private, lines) {
  message(lines, appendLF = FALSE)
  private$margin <- 0
}

cli__cat_ln <- function(self, private, lines, indent) {
  style <- private$get_style()$main

  ## left margin
  left <- style$`margin-left` %||% 0
  if (length(lines) && left) lines <- paste0(strrep(" ", left), lines)

  ## indent or negative indent
  if (length(lines)) {
    if (indent < 0) {
      lines[1] <- dedent(lines[1], - indent)
    } else if (indent > 0) {
      lines[1] <- paste0(strrep(" ", indent), lines[1])
    }
  }

  ## zero out margin
  private$margin <- 0

  bar <- private$get_progress_bar()
  if (is.null(bar)) {
    message(paste0(lines, "\n"), appendLF = FALSE)
  } else {
    bar$message(lines, set_width = FALSE)
  }
}

cli__vspace <- function(self, private, n) {
  if (private$margin < n) {
    message(strrep("\n", n - private$margin), appendLF = FALSE)
    private$margin <- n
  }
}
