`%||%` <- function(a, b) { # nolint
  if (is.null(a)) b else a
}


vlapply <- function(x, fun, ...) {
  vapply(x, fun, logical(1), ...)
}

viapply <- function(x, fun, ...) {
  vapply(x, fun, integer(1), ...)
}

vcapply <- function(x, fun, ...) {
  vapply(x, fun, character(1), ...)
}


collector <- function(...) {
  odin:::collector(...)
}


dust_flatten_eqs <- function(...) {
  odin:::c_flatten_eqs(...)
}


dust_fold_call <- function(...) {
  odin:::c_fold_call(...)
}


dquote <- function(...) {
  odin:::dquote(...)
}


squote <- function(...) {
  odin:::squote(...)
}


dust_array_access <- function(target, index, data, meta, supported) {
  mult <- data$elements[[target]]$dimnames$mult

  f <- function(i) {
    index_i <- dust_minus_1(index[[i]], i > 1, data, meta, supported)
    if (i == 1) {
      index_i
    } else {
      mult_i <- generate_dust_sexp(mult[[i]], data, meta, supported)
      sprintf("%s * %s", mult_i, index_i)
    }
  }

  paste(vcapply(rev(seq_along(index)), f), collapse = " + ")
}


dust_minus_1 <- function(x, protect, data, meta, supported) {
  if (is.numeric(x)) {
    generate_dust_sexp(x - 1L, data, meta, supported)
  } else {
    x_expr <- generate_dust_sexp(x, data, meta, supported)
    sprintf(if (protect) "(%s - 1)" else "%s - 1", x_expr)
  }
}


dust_plus_1 <- function(x, rewrite) {
  if (is.numeric(x)) {
    rewrite(x + 1)
  } else {
    sprintf("%s + 1", rewrite(x))
  }
}


cpp_function <- function(return_type, name, args, body) {
  c(cpp_args(return_type, name, args), paste0("  ", body), "}")
}


cpp_args <- function(return_type, name, args) {
  args_str <- paste(sprintf("%s %s", names(args), unname(args)),
                    collapse = ", ")
  sprintf("%s %s(%s) {", return_type, name, args_str)
}


odin_dust_file <- function(path) {
  system.file(path, package = "odin.dust", mustWork = TRUE)
}


is_call <- function(expr, symbol) {
  is.recursive(expr) && identical(expr[[1L]], as.name(symbol))
}


generate_dust_support_sum <- function(rank) {
  if (rank == 1) {
    list(name = "odin_sum1",
         declaration = c(
           "template <typename T>",
           "T odin_sum1(const T * x, size_t from, size_t to);"),
         definition = NULL)
  } else {
    ## There are a series of substitutions that need to be made here,
    ## all of which are literal
    tr <- c("double*" = "const real_t *",
            "double" = "real_t")
    head <- "template <typename real_t>"
    ret <- lapply(odin:::generate_c_support_sum(rank), replace, tr)
    ret$declaration <- c(head, ret$declaration)
    ret$definition <- c(head, ret$definition)
    ret
  }
}


dust_type <- function(type) {
  switch(type,
         double = "real_t",
         int = "int",
         stop(sprintf("Unknown type '%s'", type)))
}


replace <- function(x, tr) {
  from <- names(tr)
  for (i in seq_along(tr)) {
    x <- gsub(from[[i]], tr[[i]], x, fixed = TRUE)
  }
  x
}


deparse_fun <- function(x) {
  stopifnot(is.function(x))
  str <- paste(sub("\\s+$", "", deparse(x)), collapse = "\n")
  ## Apply a few fixes:
  str <- gsub("function (", "function(", str, fixed = TRUE)
  str <- gsub("\\)\n\\{", ") {", str)
  str <- gsub("\\}\n\\s*else", "} else", str)
  str
}


deparse_str <- function(x) {
  paste(deparse(x), collapse = "\n")
}
