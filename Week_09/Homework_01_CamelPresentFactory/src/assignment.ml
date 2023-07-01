type behavior = Nice | Naughty

type notes = (string * behavior) list

type selection_alg = (string * int * int) list -> int -> string list

exception Invalid_file_format of string

let load_lines filename = (* Return with reversed (item, data) list *)
  try let infile = open_in filename in
    let split_line line = match String.split_on_char ':' line with
      | [item; data] -> if String.length item > 0 then (item, data) (* non-empty item name *)
                        else raise (Invalid_file_format filename)
      | _ -> raise (Invalid_file_format filename)
    in
    let rec load_lines_aux acc =
      try
        let line = input_line infile in
        load_lines_aux (split_line line :: acc)
      with
        | End_of_file -> close_in infile; acc
        | _ -> close_in infile; raise (Invalid_file_format filename)
    in load_lines_aux []
  with Sys_error _ -> raise (Invalid_file_format filename)

let read_notes filename = (* Contains all the kids *)
  let items = load_lines filename in
  let rec process_lines acc = function
    | [] -> acc
    | (name, behavior) :: rest -> (match behavior with
      | "nice" -> process_lines ((name, Nice) :: acc) rest
      | "naughty" -> process_lines ((name, Naughty) :: acc) rest 
      | _ -> raise (Invalid_file_format filename))
  in process_lines [] items

let read_wishlist filename = (* For one kid *)
  let items = load_lines filename in
  let rec process_lines acc = function
    | [] -> acc
    | (wish, importance_string) :: rest -> 
      try
        let importance = int_of_string importance_string in
        if importance >= 1 && importance <= 100 then process_lines ((wish, importance) :: acc) rest
        else raise (Invalid_file_format filename)
      with Failure _ -> raise (Invalid_file_format filename)
  in process_lines [] items

let load_catalogue filename = 
  let items = load_lines filename in
  let rec process_lines acc = function
    | [] -> acc
    | (toy, weight_string) :: rest -> 
      try
        let weight = int_of_string weight_string in
        if weight > 0 then process_lines ((toy, weight) :: acc) rest
        else raise (Invalid_file_format filename)
      with Failure _ -> raise (Invalid_file_format filename)
  in process_lines [] items

let write_list filename presents = 
  let outfile = open_out filename in
  let rec write_list_aux = function
    | [] -> close_out outfile
    | present :: rest -> 
      output_string outfile (present ^ "\n");
      write_list_aux rest
  in try write_list_aux presents
  with _ -> close_out outfile

let write_letter filename = 
  let outfile = open_out filename in
  let extract_name filename = (* letters/name.txt *) (* Bonus *)
    try
      let start_index = String.rindex filename '/' + 1 in
      let end_index = String.rindex filename '.' in
      String.sub filename start_index (end_index - start_index)
    with _ -> raise (Invalid_file_format filename)
  in
  let name = extract_name filename in
  let letter =
    "Dear " ^ name ^ ",\n\n" ^
    "I hope this letter finds you well. It has come to my attention that you have been a bit naughty this year.\n" ^
    "While I understand that sometimes we make mistakes, it is important to remember to be polite and respectful.\n" ^
    "In order to receive presents next year, I encourage you to stick to your programming exercises and practice good behavior.\n" ^
    "Remember, kindness and hard work go a long way.\n\n" ^
    "Wishing you all the best,\n" ^
    "The Deliverer"
  in try output_string outfile letter; close_out outfile
  with _ -> close_out outfile

let run_desert_factory capacity selectionAlg =
  let toys_catalogue = load_catalogue "toys_catalogue.txt" in
  let notes = read_notes "deliverers_notes.txt" in
  let rec presents_list acc = function (* return with (toy, importance, weight) list *)
    | [] -> acc
    | (toy, importance) :: rest ->
      try (* Toys on the child's wish list that are not available (in the catalogue) have to be removed from the list. *)
        let weight = List.assoc toy toys_catalogue in
        presents_list ((toy, importance, weight) :: acc) rest
      with Not_found -> presents_list acc rest
  in
  let rec handle_notes = function
    | [] -> ()
    | (name, behavior) :: rest -> (match behavior with
      | Naughty -> write_letter ("letters/" ^ name ^ ".txt"); handle_notes rest
      | Nice ->
        (* If a child's wish list is invalid,
           that child is simply ignored and everyone else still has to get their presents. *)
        try
          let wishlist = read_wishlist ("wishlists/" ^ name ^ ".txt") in
          let presents = selectionAlg (presents_list [] wishlist) capacity in
          write_list ("presents/" ^ name ^ ".txt") presents;
          handle_notes rest
        with Invalid_file_format _ -> handle_notes rest)
  in handle_notes notes

let knapsack presents capacity = (* 01-knapsack using recursion *)
  let rec knapsack_aux presents capacity = match presents with
    | [] -> [], 0 (* No items left *)
    | (toy, importance, weight) :: rest ->
      if weight > capacity then
        knapsack_aux rest capacity (* Item too heavy *)
      else
        let (item_with, value_with) = knapsack_aux rest (capacity - weight) in
        let (item_without, value_without) = knapsack_aux rest capacity in
        if value_with + importance > value_without then
          (toy :: item_with, value_with + importance) (* Include current item *)
        else
          (item_without, value_without) (* Exclude current item *)
  in List.rev (fst (knapsack_aux presents capacity))
