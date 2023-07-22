type configuration = {
  board_width : int;
  board_height : int;
  starting_camels : int;
}

type position = int * int (* x, y *)

type camel = H of position
          | V of position

type random_supplier = unit -> float
type time_supplier = unit -> float (* available time *)

type direction = Up
               | Down
               | Left
               | Right
               | UpLeft
               | UpRight
               | DownLeft
               | DownRight

type player = {
  position : position;
  current_camels : int;
}

type game_state = {
  camels : camel list;
  players : player list;
  next_player : int;
}

type move = Move of direction
          | Camel of camel

(** configuration -> game state -> move -> is valid *)
type move_validator = configuration -> game_state -> move -> bool

(** configuration -> game state -> list of valid moves *)
type move_lister = configuration -> game_state -> move list

(** configuration -> game state (next_player - 1 mod player count has just played) -> whether the current player has won *)
type win_checker = configuration -> game_state -> bool

(** current state, make the given move for next_player *)
type move_applier = configuration -> game_state -> move -> game_state

(** supplier of random numbers -> supplier of remaining time -> configuration -> initial state (which player you are is the length of the move list on the first call to make_move)*)
type 'a state_initializer = random_supplier -> time_supplier -> configuration -> 'a

type 'a move_maker = random_supplier -> time_supplier -> configuration -> move list -> 'a -> move * 'a

type game_engine =
  Engine : 'a state_initializer * 'a move_maker -> game_engine

type running_game_engine =
  RunningEngine : 'a * 'a move_maker -> running_game_engine
