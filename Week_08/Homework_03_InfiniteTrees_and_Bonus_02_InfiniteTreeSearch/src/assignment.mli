type 'a tree = Empty | Node of 'a * 'a tree * 'a tree
type 'a ltree = LNode of 'a * (unit -> 'a ltree) * (unit -> 'a ltree)

val layer_tree : int -> int ltree
val interval_tree : float -> float -> (float * float) ltree
val rational_tree : int -> int -> (int * int) ltree

val top : int -> 'a ltree -> 'a tree
val map : ('a -> 'b) -> 'a ltree -> 'b ltree
val find : ('a -> bool) -> 'a ltree -> 'a ltree
