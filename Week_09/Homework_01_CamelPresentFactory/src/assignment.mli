type behavior = Nice | Naughty

type notes = (string * behavior) list

type selection_alg = (string * int * int) list -> int -> string list

exception Invalid_file_format of string

val read_notes : string -> notes

val read_wishlist : string -> (string * int) list

val load_catalogue : string -> (string * int) list

val write_list : string -> string list -> unit

val write_letter : string -> unit

val run_desert_factory : int -> selection_alg -> unit

val knapsack : selection_alg