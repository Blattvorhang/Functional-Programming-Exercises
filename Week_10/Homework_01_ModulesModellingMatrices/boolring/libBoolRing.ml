open Common
open LibRing

module BoolRing = struct
  type t = bool
  let elems = [true; false]
  let zero = false
  let one = true
  let add = ( <> ) (* exclusive or *)
  let mul = ( && ) (* conjunction *)
  let compare = compare
  let to_string = string_of_bool
end
