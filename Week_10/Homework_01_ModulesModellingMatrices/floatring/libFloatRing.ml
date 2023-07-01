open Common
open LibRing

module FloatRing = struct
  type t = float
  let zero = 0.
  let one = 1.
  let add = ( +. )
  let mul = ( *. )
  let compare = compare
  let to_string = string_of_float
end
