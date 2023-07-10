# Expression Evaluation
We define expressions over rationals using these OCaml types:

```ocaml
type rat = int * int (* num, denom *)
type unary_op = Neg
type binary_op = Add | Sub | Mul | Div
type expr = Const of rat
          | UnOp of unary_op * expr
          | BinOp of binary_op * expr * expr
```

---

**eval_expr**  
Implement a function

```ocaml
eval_expr : expr -> rat
```

that evaluates the given expression. The resulting fraction **must** be irreducible (i.e. simplified or in lowest terms), so for example `(-3,2)` and `(3,-2)` are accepted, but `(-6,4)` and `(12,-8)` are **not**. Be careful to avoid integer overflow **during** evaluation.

You **may** assume that all expressions passed to `eval_expr` will not cause division by zero to occur.

You may **not** assume that all `rat`s passed to `eval_expr` will be irreducible.

---

Example:

```ocaml
eval_expr (BinOp (Mul, BinOp (Sub, Const (3,8), Const (2,4)), Const (6,-3)))
```

evaluates to `(1,4)` (or `(-1,-4)`, but not `(2,8)`, `(-2,-8)`, …)
