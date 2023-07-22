open Thread
open Event

exception Out_of_bounds

module Array = struct
  type 'a op =
    | Size of int channel
    | Set of int * 'a * bool channel
    | Get of int * 'a option channel
    | Resize of int * 'a
    | Destroy
  type 'a t = 'a op channel
  
  let make s v =
    let array_channel = new_channel () in
    let rec new_array (s : int) (v : 'a) (acc : 'a list) =
      if s = 0 then acc
      else new_array (s - 1) v (v :: acc)
    in
    let rec operation (arr : 'a list) =
      match sync (receive array_channel) with
      | Size c ->
        let _ = sync (send c (List.length arr)) in
        operation arr
      | Set (i, v, c) ->
        if i < 0 || i >= List.length arr then
          let _ = sync (send c false) in
          operation arr
        else
          let _ = sync (send c true) in
          operation (List.mapi (fun j x -> if j = i then v else x) arr)
      | Get (i, c) ->
        if i < 0 || i >= List.length arr then
          sync (send c None)
        else
          sync (send c (Some (List.nth arr i)));
        operation arr  (* Side-effect *)
      | Resize (s, v) ->
        let rec resize_aux s v acc = function
          | [] -> List.rev_append acc (new_array s v [])
          | x :: xs ->
            if s = 0 then List.rev acc
            else resize_aux (s - 1) v (x :: acc) xs
        in
        operation (resize_aux s v [] arr)
      | Destroy -> raise Exit
    in
    let _ = create operation (new_array s v []) in
    array_channel

  let size a =
    let back = new_channel () in
    sync (send a (Size back));
    sync (receive back)

  let set i v a =
    let back = new_channel () in
    sync (send a (Set (i, v, back)));
    if sync (receive back) then ()
    else raise Out_of_bounds

  let get i a =
    let back = new_channel () in
    sync (send a (Get (i, back)));
    match sync (receive back) with
    | None -> raise Out_of_bounds
    | Some v -> v

  let resize s v a = sync (send a (Resize (s, v)))

  let destroy a = sync (send a Destroy)

end