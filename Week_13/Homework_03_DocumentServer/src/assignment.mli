exception Invalid_operation of string

type t

val document_server : unit -> t
val add_account : string -> string -> t -> unit
val publish : string -> string -> string -> t -> int
val view : string -> string -> int -> t -> string
val add_viewer : string -> string -> int -> string -> t -> unit
val change_owner : string -> string -> int -> string -> t -> unit