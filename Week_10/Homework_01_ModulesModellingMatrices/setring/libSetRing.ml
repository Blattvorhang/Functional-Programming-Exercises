open Common
open LibRing
open LibFiniteRing

module SetRing = functor (D : FiniteRing) ->
  struct
    type t = D.t list (* set *)
    let zero = []     (* empty set *)
    let one = D.elems (* universe *)

    let rec add a b = (* union *)
      match a with
      | [] -> b
      | x::xs -> if List.mem x b then add xs b else add xs (x::b) (* tail recursive *)

    let rec mul a b = (* intersection *)
      match a with
      | [] -> []
      | x::xs -> if List.mem x b then x::(mul xs b) else mul xs b

    let compare a b = (* lexicographical *)
      let rec compare_aux a b = match a, b with
        | [], [] -> 0
        | [], _ -> -1
        | _, [] -> 1
        | x::xs, y::ys -> let c = D.compare x y in if c = 0 then compare_aux xs ys else c
      in compare_aux (List.sort_uniq D.compare a) (List.sort_uniq D.compare b)
      
    let to_string s =
      let rec to_string_aux = function
        | [] -> ""
        | [x] -> D.to_string x (* no comma *)
        | x::xs -> (D.to_string x) ^ ", " ^ (to_string_aux xs)
      in "{" ^ (to_string_aux s) ^ "}"
  end
