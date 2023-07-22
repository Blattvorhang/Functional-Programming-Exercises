open Thread
open Event

let app ch f x = sync (send ch (f x))

let par_app2 (f : 'a -> 'b) (g : 'c -> 'd) (x : 'a) (y : 'c) : ('b * 'd) =
  (* run f and g in parallel *)
  let ch1 = new_channel () in
  let ch2 = new_channel () in
  let _ = create (app ch1 f) x in
  let _ = create (app ch2 g) y in
  (sync (receive ch1), sync (receive ch2))

let par_map (f : 'a -> 'b) (xs : 'a list) : 'b list =
  (* in the same order as the input list *)
  let rec loop_send chs = function
    | [] -> chs
    | x::xs -> 
      let ch = new_channel () in
      let _ = create (app ch f) x in
      loop_send (ch::chs) xs
  in
  let rec loop_receive acc = function
    | [] -> acc
    | ch::chs -> 
      let y = sync (receive ch) in
      loop_receive (y::acc) chs
  in
  let chs = loop_send [] xs in
  loop_receive [] chs
  