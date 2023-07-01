let f1 acc v = acc + 1

let f2 acc v = if List.length v > List.length acc then v else acc

let f3 acc (a, b) = acc@[(b, a)]

let f4 acc v = v::List.rev acc

let f5 acc (k, v) = fun x -> if x = k then v else acc x

let f6 acc v = match acc with 
  | [] -> failwith "empty list"
  | x::_ -> v x::acc

let f7 acc v = acc * acc * v