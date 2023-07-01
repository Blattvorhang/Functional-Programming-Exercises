open Common
open LibRing

module type FiniteRing = sig
  include Ring
  val elems : t list
end
