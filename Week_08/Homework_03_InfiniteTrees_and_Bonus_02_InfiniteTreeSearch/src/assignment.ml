type 'a tree = Empty | Node of 'a * 'a tree * 'a tree
type 'a ltree = LNode of 'a * (unit -> 'a ltree) * (unit -> 'a ltree)

let rec layer_tree r = LNode (r, (fun () -> layer_tree (r+1)), (fun () -> layer_tree (r+1)))
let rec interval_tree l h =
  let mid = (l +. h) /. 2. in
  LNode ((l, h), (fun () -> interval_tree l mid), (fun () -> interval_tree mid h))
let rec rational_tree n d = LNode ((n, d), (fun () -> rational_tree n (d+1)), (fun () -> rational_tree (n+1) d))

let rec top n t = 
  let LNode (v, left, right) = t in
  if n = 0 then Empty else Node (v, top (n-1) (left ()), top (n-1) (right ()))
let rec map f t =
  let LNode (v, left, right) = t in
  LNode (f v, (fun () -> map f (left ())), (fun () -> map f (right ())))
let find p t =
  let rec bfs = function
    | [] -> failwith "Not found"
    | LNode (v, left, right) :: rest ->
      if p v then LNode (v, left, right) else bfs (rest @ [left (); right ()])
  in bfs [t]
