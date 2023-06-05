open Type

let rec add a b = match (a, b) with
  | (_, Zero) -> a  (* a + 0 = a *)
  | (_, Succ b') -> add (Succ a) b' (* a + (Succ b') = (Succ a) + b' *)

let rec mul a b = match (a, b) with
  | (_, Zero) -> Zero  (* a * 0 = 0 *)
  | (_, Succ b') -> add a (mul a b') (* a * (Succ b') = a + (a * b') *)

let rec pow a b = match (a, b) with
  | (_, Zero) -> Succ Zero  (* a ^ 0 = 1 *)
  | (_, Succ b') -> mul a (pow a b') (* a ^ (Succ b') = a * (a ^ b') *)

let rec leq a b = match (a, b) with
  | (Zero, _) -> true  (* 0 <= b *)
  | (_, Zero) -> false  (* a > 0 *)
  | (Succ a', Succ b') -> leq a' b' (* (Succ a') <= (Succ b') = a' <= b' *)
