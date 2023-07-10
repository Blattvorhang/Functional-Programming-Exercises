# Crawling on Trees
Once again, consider binary trees, which we define as:

```ocaml
type tree = Empty | Node of int * tree * tree
```

In this assignment you are supposed to implement a crawler that walks along binary trees and performs different operations. At any time, the crawler “sits” on a particular node of the tree (this includes the `Empty`-leaf). In the following we refer to this node as the current node. Furthermore, the crawler uses a stack to store trees. Initially, the crawler is positioned at the input tree’s root and is then instructed using the commands

```ocaml
type command = Left | Right | Up | New of int | Delete | Push | Pop
```

with the following meaning:

- `Left` moves the crawler to the current node’s left child.
- `Right` moves the crawler to the current node’s right child.
- `Up` moves the crawler up to the current node’s parent node.
- `New` x replaces the current node (including all children) with a new node with value x.
- `Delete` removes the current node (including all children) leaving behind an Empty- leaf.
- `Push` pushes the subtree rooted at the current node onto the stack. The tree stays unchanged.
- `Pop` replaces the subtree rooted at the current node with the topmost tree of the stack. The tree is then popped from the stack.

1. **crawl**  
Implement a function crawl : `command list -> tree -> tree` that executes a list of crawler commands on the given tree.
You may assume that the list of commands is always valid, so there is no `Left` or `Right` when the crawler is already at a leaf, no `Up` when it is on the root and no `Pop` when the stack is empty.

*Hint: The tricky part is to get the `Up` command right. If you do not manage to implement this correctly, leave it out and you will still get some points if the rest is correct.*

*Hint: The function `print_tree` is provided, that can be used to export your tree to the [dot-format](https://en.wikipedia.org/wiki/DOT_(graph_description_language)). You could use https://edotor.net/ to visualize the output.*
