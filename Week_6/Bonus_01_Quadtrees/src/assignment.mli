type quadtree_node = NoPoint
                   | Point of int * int
                   | QNode of quadtree_node (* bottom left *)
                            * quadtree_node (* top left *)
                            * quadtree_node (* bottom right *)
                            * quadtree_node (* top right *)
type quadtree = { width:int; height:int; root:quadtree_node }

val insert : (int * int) -> quadtree -> quadtree