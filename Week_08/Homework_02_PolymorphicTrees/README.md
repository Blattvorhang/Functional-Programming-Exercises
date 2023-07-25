# Polymorphic Trees
So far, we used a very inflexible definition of binary trees for storing integer values. Now, we relax this limitation by defining the binary tree as a polymorphic type, such that arbitrary values may be stored at the nodes:

```ocaml
type 'a tree = Empty | Node of 'a * 'a tree * 'a tree
```

Complete the following tasks using the above definition:

1. **insert**  
    Implement a function `insert : ('a -> 'a -> int) -> 'a -> 'a tree -> 'a tree` to insert a value (second argument) into the tree (third argument) while preserving the binary search tree invariant (without changing the position or values of any other nodes). If the new value is considered equal to an existing value, it should not be inserted. Note, since we do not know the type stored in the tree, the default comparison operators (`<`, `<=`, …) cannot be used anymore to decide where to insert a new value. Imagine that we could use the tree to store `student` records ordered by `id`. Instead, a compare function has to be passed to `insert` as the first argument. This function compares two values of type `'a` and has to return a negative number if the first value goes before the second, a positive number if the second goes before the first, and $0$ if both values are considered equal.

2. **string_of_tree**  
    Implement a function `string_of_tree : ('a -> string) -> 'a tree -> string` that constructs a string representation of the given tree. For example, for `Node (7, Node (3, Empty, Empty), Empty)`, the string shall be `"Node (7, Node (3, Empty, Empty), Empty)"`. Again, in order to tell `string_of_tree` how to convert type `'a` to a `string`, a corresponding function has to be passed as the first argument.

    *Hint: The tests compare the string case-sensitively, but space-insensitively.*

3. **inorder_list**  
    Implement a function `inorder_list : 'a tree -> 'a list` that outputs all values inside the tree to a list in order. The function **must** be tail recursive. In particular, your function must only use constant stack space.

    *Hint: `xs @ ys`, for example, is not tail-recursive and uses stack space in* $\mathcal{O}(\texttt{length\enspace xs})$