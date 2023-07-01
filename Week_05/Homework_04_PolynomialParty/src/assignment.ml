let eval_poly x poly = 
  let rec loop x poly acc = match poly with (* accumulator *)
    | [] -> acc
    | c::poly -> loop x poly (c +. x *. acc)
  in
  match poly with
    | [] -> 0.
    | cn::poly -> loop x poly cn

let derive_poly poly =
  let rec loop poly = match poly with (* return with (result, degree) *)
    | [] -> ([], -1)
    | c::poly -> let (result, degree) = loop poly in
      if degree = -1 then ([], 0)
      else ((c *. (float_of_int (degree + 1)))::result, degree + 1)
  in
  let (result, _) = loop poly in result
