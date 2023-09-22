# Shifting Sands
In the far-away land of Camelia lived in every city and town a wise OCaml sage. They lived mostly solitary lives; although they would embark on travels through Camelia in years when a Silver Moon occurred. Though infrequent, such expeditions were nevertheless indispensable in the spiritual journey of an OCaml sage; for it was here that they shared their knowledge about camel care, as well as their functional programming wisdom, with each other.

In the 19th year of the Silver Moon, sages all across Camelia were gathering their best functional pearls and ensuring that their trusty camels were getting enough rest for the journey ahead, when a smell in the air sent a chill down their spine. In the land of the United State to the south, imperative programmers had started implementing their algorithms without persistent data structures! The continuous mechanical grind of mutating state sent a rumbling into the depths of the earth, sending vast amounts of sand from Camelia's dunes into the atmosphere. Soon the sand had been deposited in alleyways, on rooftops, and in gardens, and had blanketed Camelia's road network in an impenetrable blanket of sand!

Communicating by avian carrier, the OCaml sages quickly agreed that a network of roads was to be kept clear, both for the sages' upcoming travels and for the use of Camelia's citizens. However, since Camelia was not rich in material wealth, it was agreed that not all roads could be cleared. Instead, the sages tasked their cartographers to provide them with a list of roads, such that every town and city, whether big or small, was connected on some path. Additionally, the total length of the roads was to be kept as small as possible to reduce plowing costs.

Thus the young cartographer Vojtěch proposed a solution:

- They would start with the map of Camelia, where towns were labelled as vertices, and the roads between them as edges (along with the length of such roads).
- First, they marked their home town on the map, and initially left all roads unmarked.
- Then, they considered all unmarked roads that connected a marked town to an unmarked town.
- Of those roads, they chose the shortest, and marked both that road and the previously unmarked town it was connected to on the map.
- This they would repeat until all towns had been marked.

The roads that were now marked would satisfy the sages' demands.

Thanks to Vojtěch's idea, Camelia could muster just enough plowing camels to keep all towns connected, and the sages could embark on their travels once more.

## Minimal Spanning Tree
As a simplified representation of towns and roads, we define a weighted undirected graph as the list of its edges:

```ocaml
type graph = (int * float * int) list
```
Thus, `[(0,1.5,1); (0,2.5,2)]` represents the graph containing the nodes $0$, $1$, $2$ and edges with weight $1.5$ and $2.5$ between nodes $0$ and $1$ and nodes $0$ and $2$, respectively.

Now, the problem the sages were trying to solve is known as the minimum spanning tree problem.

1. **mst**  
    Implement a function `mst : graph -> graph` that computes a minimum spanning tree for the given graph. You may assume that the input graph is connected. The graph may contain reflexive edges (loops), make sure your implementation can deal with them!

You may use [Vojtěch Jarník's algorithm](https://en.wikipedia.org/wiki/Prim%27s_algorithm) (variously known as Prim's algorithm or the DJP algorithm) as presented above, but you are also free to choose any other algorithm. The sample solution uses Jarník's algorithm. Note, that the function returns the subgraph that forms the minimum spanning tree. The edges may be output in any order.

*Hint: The `List` module provides many useful functions for this assignment!*
