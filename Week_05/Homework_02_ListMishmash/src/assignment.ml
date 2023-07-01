let rec interleave2 l1 l2 = match l1, l2 with
  | [], [] -> []
  | x::xs, [] | [], x::xs -> x::xs
  | x::xs, y::ys -> x::y::interleave2 xs ys

let rec interleave3 l1 l2 l3 = match l1, l2, l3 with
  | [], [], [] -> []
  | x::xs, [], [] | [], x::xs, [] | [], [], x::xs -> x::xs
  | x::xs, y::ys, [] | x::xs, [], y::ys | [], x::xs, y::ys -> x::y::interleave2 xs ys
  | x::xs, y::ys, z::zs -> x::y::z::interleave3 xs ys zs
