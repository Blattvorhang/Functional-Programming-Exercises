module type Ring = sig
  type t
  val zero : t
  val one : t
  val compare : t -> t -> int
  val to_string : t -> string
  val add : t -> t -> t
  val mul : t -> t -> t
end
