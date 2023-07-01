open Common
open LibRing
open LibMatrix

module SparseMatrix = functor (R : Ring) ->
  struct
    type elem = R.t
    (* for matrix m*n, rows from 0 to m-1, columns from 0 to n-1 *)
    (* order is not preserved *)
    type triplet = { i : int ; j : int ; v : elem }
    type t = { elems : triplet list ; rows : int ; cols : int }

    let create n m = { elems = [] ; rows = n ; cols = m }

    let identity n =
      let rec identity_diag i acc = (* tail recursive *)
        if i = 0 then acc
        else identity_diag (i - 1) ({ i = i - 1 ; j = i - 1 ; v = R.one } :: acc)
      in { elems = identity_diag n [] ; rows = n ; cols = n }
      
    let row_count m = m.rows

    let col_count m = m.cols

    let from_rows l =
      let rec from_rows_elem r c acc = function (* tail recursive *)
        | [] -> acc
        | x::xs -> from_rows_elem r (c + 1) ({ i = r ; j = c ; v = x } :: acc) xs
      in
      let rec from_rows_rows r acc = function (* tail recursive *)
        | [] -> acc
        | x::xs -> from_rows_rows (r + 1) (from_rows_elem r 0 acc x) xs
      in
      { elems = from_rows_rows 0 [] l ; rows = List.length l ; cols = List.length (List.hd l) }

    let set r c v m =
      let rec set_elem = function (* not tail recursive *)
        | [] -> [{ i = r ; j = c ; v = v }]
        | x::xs -> if x.i = r && x.j = c then { i = r ; j = c ; v = v } :: set_elem xs else x :: set_elem xs
      in
      { elems = set_elem m.elems ; rows = m.rows ; cols = m.cols }

    let get r c m =
      let rec get_elem = function (* tail recursive *)
        | [] -> R.zero
        | x::xs -> if x.i = r && x.j = c then x.v else get_elem xs
      in
      get_elem m.elems

    let transpose m =
      let rec transpose_elem acc = function (* tail recursive *)
        | [] -> acc
        | x::xs -> transpose_elem ({ i = x.j ; j = x.i ; v = x.v } :: acc)  xs
      in
      { elems = transpose_elem [] m.elems ; rows = m.cols ; cols = m.rows }
    
    let add a b =
      let rec add_row elems cols i j =
        if j = cols then elems
        else let v = R.add (get i j a) (get i j b) in
          if v = R.zero then
            add_row elems cols i (j + 1)
          else
            add_row ({ i = i ; j = j ; v = v } :: elems) cols i (j + 1)
      in
      let rec add_rows elems rows cols i =
        if i = rows then elems
        else add_rows (add_row elems cols i 0) rows cols (i + 1)
      in
      { elems = add_rows [] a.rows a.cols 0 ; rows = a.rows ; cols = a.cols }

    let mul a b = (* c_{ij} = \Sigma_k a_{ik} b_{kj} *)
      let rec sum i j k =
        if k = a.cols then R.zero
        else R.add (R.mul (get i k a) (get k j b)) (sum i j (k + 1))
      in
      let rec mul_row elems cols i j =
        if j = cols then elems
        else let v = sum i j 0 in
          if v = R.zero then
            mul_row elems cols i (j + 1)
          else
            mul_row ({ i = i ; j = j ; v = v } :: elems) cols i (j + 1)
      in
      let rec mul_rows elems rows cols i =
        if i = rows then elems
        else mul_rows (mul_row elems cols i 0) rows cols (i + 1)
      in
      if a.cols <> b.rows then
        failwith "mul: matrices have incompatible dimensions"
      else
        { elems = mul_rows [] a.rows b.cols 0 ; rows = a.rows ; cols = b.cols }

    let to_string m =
      let rec to_string_row elems cols i j =
        if j = cols - 1 then R.to_string (get i j m)
        else R.to_string (get i j m) ^ " " ^ to_string_row elems cols i (j + 1)
      in
      let rec to_string_rows elems rows cols i =
        if i = rows - 1 then to_string_row elems cols i 0
        else to_string_row elems cols i 0 ^ "\n" ^ to_string_rows elems rows cols (i + 1)
      in
      to_string_rows m.elems m.rows m.cols 0
  end
