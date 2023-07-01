open Common
open LibRing

module IntRing = struct
  type t = int
  let zero = 0
  let one = 1
  let add = ( + )
  let mul = ( * )
  let compare = compare
  let to_string = string_of_int
end
