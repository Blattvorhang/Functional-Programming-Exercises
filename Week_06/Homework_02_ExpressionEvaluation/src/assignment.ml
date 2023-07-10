type unary_op = Neg
type binary_op = Add | Sub | Mul | Div
type rat = int * int (* num, denom *)
type expr = Const of rat
          | UnOp of unary_op * expr
          | BinOp of binary_op * expr * expr


let rec gcd = function
  | (0, b) -> b
  | (a, 0) -> a
  | (a, b) -> gcd (b, a mod b)


let simplify (num, denom) =
  let g = gcd (num, denom) in
  (num / g, denom / g)


let eval_expr expr = 
  let rec eval = function
    | Const (num, denom) -> Const (simplify (num, denom))

    | UnOp (Neg, Const (num, denom)) -> Const (simplify (-num, denom))

    | BinOp (Add, Const (num1, denom1), Const (num2, denom2)) ->
      let (num1, denom1) = simplify (num1, denom1) in
      let (num2, denom2) = simplify (num2, denom2) in
      let g = gcd (denom1, denom2) in
      Const (simplify (denom2 / g * num1 + denom1 / g * num2, denom1 / g * denom2))

    | BinOp (Sub, Const (num1, denom1), Const (num2, denom2)) ->
      let (num1, denom1) = simplify (num1, denom1) in
      let (num2, denom2) = simplify (num2, denom2) in
      let g = gcd (denom1, denom2) in
      Const (simplify (denom2 / g * num1 - denom1 / g * num2, denom1 / g * denom2))

    | BinOp (Mul, Const (num1, denom1), Const (num2, denom2)) ->
      let (num1, denom1) = simplify (num1, denom1) in
      let (num2, denom2) = simplify (num2, denom2) in
      let (num1, denom2) = simplify (num1, denom2) in
      let (num2, denom1) = simplify (num2, denom1) in
      Const (num1 * num2, denom1 * denom2) (* no need to simplify again *)

    | BinOp (Div, Const (num1, denom1), Const (num2, denom2)) ->
      eval (BinOp (Mul, Const (num1, denom1), Const (denom2, num2)))
    
    | UnOp (Neg, expr) -> eval (UnOp (Neg, eval expr))
    | BinOp (Add, expr1, expr2) -> eval (BinOp (Add, eval expr1, eval expr2))
    | BinOp (Sub, expr1, expr2) -> eval (BinOp (Sub, eval expr1, eval expr2))
    | BinOp (Mul, expr1, expr2) -> eval (BinOp (Mul, eval expr1, eval expr2))
    | BinOp (Div, expr1, expr2) -> eval (BinOp (Div, eval expr1, eval expr2))
  in
  let Const (num, denom) = eval expr in
  (num, denom)


(* sample inputs: should evaluate to (-3, 2) and (5, 1) respectively, after simplifying *)
let a67_ex1 = BinOp (Mul, BinOp (Sub, Const (3, 5), Const (2, 1)), BinOp (Div, Const (3, 2), Const (7, 5)))
let a67_ex2 = BinOp (Add, UnOp (Neg, a67_ex1), BinOp (Div, Const (7, 1), Const (2, 1)))

