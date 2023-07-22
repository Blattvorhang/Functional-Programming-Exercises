

exception Out_of_bounds

module Array : sig
    type 'a t

    val make : int -> 'a -> 'a t

    val size : 'a t -> int

    val set : int -> 'a -> 'a t -> unit

    val get : int -> 'a t -> 'a

    val resize : int -> 'a -> 'a t -> unit

    val destroy : 'a t -> unit
end