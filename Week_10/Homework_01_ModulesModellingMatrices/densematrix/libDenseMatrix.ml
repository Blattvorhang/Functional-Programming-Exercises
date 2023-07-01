open Common
open LibRing
open LibMatrix

module DenseMatrix = functor (R : Ring) ->
  struct
    type elem = R.t
    (* for matrix m*n, rows from 0 to m-1, columns from 0 to n-1 *)
    type t = elem list list (* Define that t_{00} is the top of stack *)

    let create n m =
      let rec create_row j =
        if j = 0 then [] else R.zero :: create_row (j - 1)
      in
      let row = create_row m in
      let rec create_rows i =
        if i = 0 then [] else row :: create_rows (i - 1)
      in
      create_rows n

    let identity n =
      let rec identity_row i j =
        if j = 0 then [] else
          if i = j then R.one :: identity_row i (j - 1)
          else R.zero :: identity_row i (j - 1)
      in
      let rec identity_rows i =
        if i = 0 then [] else identity_row i n :: identity_rows (i - 1)
      in
      identity_rows n
      
    let row_count m = 
      let rec row_count_aux acc = function
        | [] -> acc
        | _::xs -> row_count_aux (acc + 1) xs
      in row_count_aux 0 m

    let col_count m = 
      let rec col_count_aux acc = function
        | [] -> acc
        | _::xs -> col_count_aux (acc + 1) xs
      in col_count_aux 0 (List.hd m)

    let from_rows l = l

    let set r c v m =
      let rec set_column c v = function
        | [] -> failwith "set: column out of bounds"
        | x::xs -> if c = 0 then v::xs else x::set_column (c - 1) v xs
      in
      let rec set_row r c v = function
        | [] -> failwith "set: row out of bounds"
        | x::xs -> if r = 0 then set_column c v x::xs else x::set_row (r - 1) c v xs
      in
      set_row r c v m

    let get r c m =
      let rec get_column c = function
        | [] -> failwith "get: column out of bounds"
        | x::xs -> if c = 0 then x else get_column (c - 1) xs
      in
      let rec get_row r c = function
        | [] -> failwith "get: row out of bounds"
        | x::xs -> if r = 0 then get_column c x else get_row (r - 1) c xs
      in
      get_row r c m

    let transpose m =
      let rec transpose_row i j m acc =
        if j = 0 then acc else
          transpose_row i (j - 1) m (get (j - 1) (i - 1) m :: acc) (* set i j *)
      in
      let rec transpose_rows i j m acc =
        if i = 0 then acc else
          transpose_rows (i - 1) j m (transpose_row i j m [] :: acc)
      in
      transpose_rows (col_count m) (row_count m) m [] (* swap rows and columns *)

    let add a b = 
      let rec add_row = function
        | [], [] -> []
        | x::xs, y::ys -> R.add x y :: add_row (xs, ys)
        | _ -> failwith "add: matrices have different dimensions"
      in
      let rec add_rows = function
        | [], [] -> []
        | x::xs, y::ys -> add_row (x, y) :: add_rows (xs, ys)
        | _ -> failwith "add: matrices have different dimensions"
      in
      add_rows (a, b)

    let mul a b = (* c_{ij} = \Sigma_k a_{ik} b_{kj} *)
      let a_col = col_count a in
      let b_row = row_count b in
      let rec sum r c k =
        if k = 0 then R.zero else
          R.add (R.mul (get (r - 1) (k - 1) a) (get (k - 1) (c - 1) b)) (sum r c (k - 1))
      in
      let rec mul_row r c acc =
        if c = 0 then acc else
          mul_row r (c - 1) (sum r c a_col :: acc)
      in
      let rec mul_rows r c acc =
        if r = 0 then acc else
          mul_rows (r - 1) c (mul_row r c [] :: acc)
      in
      if a_col <> b_row then
        failwith "mul: matrices have incompatible dimensions"
      else
        mul_rows (row_count a) (col_count b) []

    let to_string m =
      let rec to_string_row = function
        | [] -> ""
        | [x] -> R.to_string x
        | x::xs -> R.to_string x ^ " " ^ to_string_row xs
      in
      let rec to_string_rows = function
        | [] -> ""
        | [x] -> to_string_row x
        | x::xs -> to_string_row x ^ "\n" ^ to_string_rows xs
      in
      to_string_rows m
  end
