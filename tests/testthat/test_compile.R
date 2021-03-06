# Testing high-level functions - rewrite and deparse_js
unit_test <- function(x, y) {
  f <- function(x) rewrite(parse0(x))
  # g <- purrr::compose(deparse, f)
  h <- purrr::compose(deparse_js, f)

  cat("==========Test==========", "\n")
  cat("Input             : ", x, "\n")
  # cat("Output (deparse)  : ", g(x), "\n")
  cat("Output (deparse_js) : ", h(x), "\n")

  testthat::expect_equal(h(x), y)
}

testthat::test_that("Rewriting R to JavaScript", {
  unit_test("a <- x <<- 10", "a = x = 10")
  unit_test("a <<- b <- 3 + 4", "a = b = math.add(3, 4)")
  unit_test("3^2 + 14", "math.add(math.pow(3, 2), 14)")
  unit_test("1:10 + 120", "math.add(R.seq_by(1, 10), 120)")
  unit_test("3 * pi - 3", "math.subtract(math.multiply(3, math.pi), 3)")
  unit_test("self$abc(123)", "this.abc(123)")
  unit_test("123 %% 5 == 4", "math.mod(123, 5) == 4")
  unit_test("obj_1$method_1(x)", "obj_1.method_1(x)")
  unit_test("obj_1$new(x, y)", "new obj_1(x, y)")
  unit_test("lib_1$obj_1$new(x, y)", "new lib_1.obj_1(x, y)")
  unit_test("-3", "-3")
  unit_test("2 - 3", "math.subtract(2, 3)")
  unit_test("-3 + 4", "math.add(-3, 4)")
  unit_test("-2 + 3 - 4", "math.subtract(math.add(-2, 3), 4)")
  unit_test("-(2 + 3) - 4", "math.subtract(-(math.add(2, 3)), 4)")
  unit_test("abc$abc[0]", "math.subset(abc.abc, math.index(0))")
  unit_test("if (TRUE) f(x)", "if (true) f(x)")
  unit_test("if (TRUE) f(x) else g(x)", "if (true) f(x) else g(x)")
  unit_test("let (x)", "let x")
  unit_test("let (x = 3)", "let x = 3")
  unit_test("declare (x)", "let x")
  unit_test("declare (y = 4)", "let y = 4")
  unit_test("for (i in iterables) { x }", "for (let i of iterables) {\n    x\n}")
  unit_test("list(x = 1, y = 2)", "{ x: 1, y: 2 }")
  unit_test("data.frame(x = 2, y = 2)", "new dfjs.DataFrame({ x: 2, y: 2 })")
  unit_test("ifelse(test, yes, no)", "test ? yes : no")
  unit_test("lambda(x, sin(x))", "function(x) { return math.sin(x); }")
  unit_test("function(b, c) {}", "function(b, c) {\n    \n}")
  unit_test("while (TRUE) { do(x) }", "while (true) {\n    do(x)\n}")
  unit_test("abc %op% abc", "abc %op% abc")

  # Test that function arguments are rewritten
  unit_test("function(b = TRUE, c = FALSE) {}", "function(b = true, c = false) {\n    \n}")
  unit_test("function(b = 1:3, c = 3:5) {}", "function(b = R.seq_by(1, 3), c = R.seq_by(3, 5)) {\n    \n}")
  unit_test("function(n = 2 ^ 4) {}", "function(n = math.pow(2, 4)) {\n    \n}")
  unit_test("function(n = 3 ^ 2 ^ 2) {}", "function(n = math.pow(3, math.pow(2, 2))) {\n    \n}")

  # Test conditional rewriting
  unit_test("a$length", "a.length")
  unit_test("obj_1$length <- length(abcde)", "obj_1.length = R.length(abcde)")
  unit_test("length(obj_1$length$max)", "R.length(obj_1.length.max)")

})
