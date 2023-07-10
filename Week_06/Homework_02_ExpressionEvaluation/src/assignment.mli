type unary_op = Neg
type binary_op = Add | Sub | Mul | Div
type rat = int * int (* num, denom *)
type expr = Const of rat
          | UnOp of unary_op * expr
          | BinOp of binary_op * expr * expr

val eval_expr : expr -> rat
