let interleave3 l1 l2 l3 = 
  let rec interleave2_tailrec l1 l2 acc =
    match l1 with [] -> List.rev_append acc l2
    | x::xs -> interleave2_tailrec l2 xs (x::acc)
  in
  let rec interleave3_tailrec l1 l2 l3 acc =
    match l1 with [] -> interleave2_tailrec l2 l3 acc
    | x::xs -> interleave3_tailrec l2 l3 xs (x::acc)
  in interleave3_tailrec l1 l2 l3 []
