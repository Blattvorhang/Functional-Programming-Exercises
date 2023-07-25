# Infinite Trees
The next restriction we are now going to relax is the limitation to finite trees. It is clear that we cannot store infinite trees in finite memory, thus, we have to define the trees in a lazy fashion, such that only the subtree that is actually required is constructed, while the rest is not. Let the type

```ocaml
type 'a ltree = LNode of 'a * (unit -> 'a ltree) * (unit -> 'a ltree)
```

define polymorphic lazy (infinite) binary trees. Instead of storing a left and right child directly, we keep a function to construct them if ever needed. Note, that we no longer need an Empty constructor, since our trees are always infinite.

Implement the following functions for infinite tree construction:

1. `layer_tree : int -> int ltree`  
    $\texttt{layer\\_tree}\enspace r$ constructs an infinite tree where all nodes of the $n$th layer store the value $r+n$. We consider the root as layer $0$, so the root stores value $r$.
2. `interval_tree : float -> float -> (float * float) ltree`  
    $\texttt{interval\\_tree}\enspace l_0\enspace h_0$ constructs a tree where the left and right child of every node with interval $(l,h)$ store the intervals $(l, \frac{l+h}{2})$ and $(\frac{l+h}{2}, h)$, respectively. The root stores the interval $(l_0​,h_0)$ passed as the function's arguments.
3. `rational_tree : int -> int -> (int * int) ltree`  
    $\texttt{rational\\tree}\enspace n_0\enspace d_0$ constructs a tree with root $(n_0,d_0)$ and for every node with pair $(n,d)$, the left child stores $(n,d+1)$ and the right child stores $(n+1,d)$.

Implement the following functions to work with infinite trees:

1. `top : int -> 'a ltree -> 'a tree`  
    $\texttt{top}\enspace n\enspace t$ returns the top $n$ layers of the given infinite tree $t$ as a finite binary tree.
2. `map : ('a -> 'b) -> 'a ltree -> 'b ltree`  
    $\texttt{map}\enspace f\enspace t$ maps all elements of the tree $t$ using the given function $f$.

## Infinite Tree Search
1. `find : ('a -> bool) -> 'a ltree -> 'a ltree`  
    $\texttt{find}\enspace p\enspace t$ returns the infinite subtree rooted at a node that satisfies the given predicate $p$. Think about how to traverse the tree to make sure that every node is visited eventually.