type 'a tree = Empty | Node of 'a * 'a tree * 'a tree

let rec insert compare value = function
  | Empty -> Node (value, Empty, Empty)
  | Node (v, left, right) -> let cp = compare value v in
    if cp < 0 then Node (v, insert compare value left, right)
    else if cp > 0 then Node (v, left, insert compare value right)
    else Node (v, left, right)

let rec string_of_tree string_of_type = function
  | Empty -> "Empty"
  | Node (v, left, right) -> "Node (" ^ string_of_type v ^ ", " ^ string_of_tree string_of_type left ^ ", " ^ string_of_tree string_of_type right ^ ")"

let inorder_list tree = 
  let rec push_left stack = function (* Push the left child *)
    | Empty -> stack
    | Node (v, left, right) -> push_left ((Node (v, left, right)) :: stack) left
  in
  let rec build_list stack acc curr = match stack with (* Pop Node from stack *)
    | [] -> acc
    | Node (v, _, right) :: rest -> build_list (push_left rest right) (v::acc) right
    | Empty :: rest -> build_list rest acc curr (* Theoretically this case won't be reached *)
  in
  List.rev (build_list (push_left [] tree) [] tree) (* Pass tree as root Node *)
