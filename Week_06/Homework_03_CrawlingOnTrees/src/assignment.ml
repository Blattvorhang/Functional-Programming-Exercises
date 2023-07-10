type tree = Empty 
          | Node of int * tree * tree
type command = Left | Right | Up | New of int | Delete | Push | Pop

(* print a graphical representation (dot) of a binary tree (2. argument) to a file (1. argument) *)
let print_tree filename btree = 
  let file = open_out filename in
  Printf.fprintf file "digraph Tree {\n";
  let rec print next_id = function Empty -> 
    Printf.fprintf file "\tn%d[shape=rectangle,label=\"\"];\n" next_id; next_id + 1, next_id
  | Node (x, l, r) ->
    let node_id = next_id in
    Printf.fprintf file "\tn%d[label=\"%d\"];\n" node_id x;
    let next_id, lid = print (next_id + 1) l in
    let next_id, rid = print next_id r in 
    (Printf.fprintf file "\tn%d -> n%d[label=\"L\"];\n" node_id lid);
    (Printf.fprintf file "\tn%d -> n%d[label=\"R\"];\n" node_id rid);
    next_id, node_id
  in
  ignore(print 0 btree);
  Printf.fprintf file "}";
  close_out file


let crawl cmds tree = 
  (* return with (subtree, isUp, cur_cmds, cur_stack)
   * subtree: the new subtree after instruction
   * isUp: whether the current instruction is Up （whether to go back to the parent node）
   * cur_cmds: the remaining commands after the current instruction
   * cur_stack: the current stack
   *)
  let rec instruct cmds cur_node stack = match cmds with 
    | [] -> (cur_node, false, [], [])
    | c::cs -> match c with
      (* Only Left, Right and Up are related to the changing of layer *)
      | Left -> (match cur_node with
        | Node (x, l, r) ->
            let (subtree, isUp, cur_cmds, cur_stack) = instruct cs l stack in
            if isUp then instruct cur_cmds (Node (x, subtree, r)) cur_stack (* backtracking *)
            else (Node (x, subtree, r), false, cs, stack)
        | Empty -> failwith "Invalid command: Left on a leaf")
      | Right -> (match cur_node with
        | Node (x, l, r) ->
            let (subtree, isUp, cur_cmds, cur_stack) = instruct cs r stack in
            if isUp then instruct cur_cmds (Node (x, l, subtree)) cur_stack (* backtracking *)
            else (Node (x, l, subtree), false, cs, stack)
        | Empty -> failwith "Invalid command: Right on a leaf")
      (* If no Up, then isUp will be false. *)
      | Up -> (cur_node, true, cs, stack) (* backtracking to avoid directly searching for the parent node *)
      | New x -> instruct cs (Node (x, Empty, Empty)) stack
      | Delete -> instruct cs Empty stack
      | Push -> instruct cs cur_node (cur_node::stack)
      (* Note: This cmd may cause a node's child or grandchild is itself, which is an infinite loop. *)
      | Pop -> (match stack with
        | top::stack' -> instruct cs top stack'
        | [] -> failwith "Invalid command: Pop on an empty stack")
  in
  let (subtree, _, _, _) = instruct cmds tree [] in subtree
