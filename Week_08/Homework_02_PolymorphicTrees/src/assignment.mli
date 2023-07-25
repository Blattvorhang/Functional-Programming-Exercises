type 'a tree = Empty | Node of 'a * 'a tree * 'a tree

val insert : ('a -> 'a -> int) -> 'a -> 'a tree -> 'a tree
val string_of_tree : ('a -> string) -> 'a tree -> string
val inorder_list : 'a tree -> 'a list
