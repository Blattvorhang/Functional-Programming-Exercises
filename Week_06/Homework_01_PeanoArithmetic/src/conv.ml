open Type

let rec int_to_nat = function
  | 0 -> Zero
  | k -> Succ (int_to_nat (k - 1))

let rec nat_to_int = function
  | Zero -> 0
  | Succ k -> 1 + nat_to_int k
