open Types

(* a type for state, may be changed in any way *)
type state

(** If two [camel]s would overlap (i.e. they cannot both be placed on a board at the same time) return [true]. *)
val camels_intersect : camel -> camel -> bool


(* EX_TODO: add list_all_moves to mli/as task? *)

(** The [game_state] contains the index of the next player. Return a list of all valid moves that player has from the current [game_state]. *)
val list_valid_moves : move_lister

(** The [game_state] contains the index of the next player. Return [true] if that player is allowed to make the given [move] from the current [game_state]. *)
val is_valid_move : move_validator

(** The [game_state] contains the index of the next player, but here we are interested in the player that most recently moved. If that player has now won, return [true]. *)
val has_won : win_checker

(** The [game_state] contains the index of the next player. Make the given [move] for that player, and return the new [game_state]. You may assume the given move is valid. *)
val apply_move : move_applier

(** Save everything you need here. See the template for an example. *)
val get_initial_state : state state_initializer

(** The given [move list] contains a list of all moves made since your last turn, which may be empty if you are the first player.
  Apply those moves to your state, then return the move you want to make and the updated state. *)
val make_move_state : state move_maker
