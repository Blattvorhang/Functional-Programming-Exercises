(** contains the simulator for running the game,
    you shouldn't need to touch anything *)

open Types
open Assignment

let (>.) f g x = f (g x)

let compose2 f l x1 x2 = f (l x1) (l x2)

(** the game_state in each of the following is the state "after" the action happens  *)
type game_log = MakeMove of (int * move * game_state * (game_log lazy_t))     (* player, move, state after move, delayed next move *)
              | InvalidMove of (int * move)                                   (* state before trying invalid move, player, (invalid) move *)
              | GameOver of int                                               (* state after winning game, (winning) player *)

let split_rev n =
  let rec impl_split_rev acc rem = function
  | [] -> acc, []
  | xs when rem = 0 -> acc, xs
  | x::xs -> impl_split_rev (x::acc) (rem - 1) xs
  in impl_split_rev [] n

let take_rev n = fst >. split_rev n

(* dummy time provider *)
let get_time (_ : Int64.t) = fun () -> 60.

let update_nth (n : int) (f : 'a -> 'a) (xs : 'a list) =
  match split_rev n xs with
  | hd, x::tl -> List.rev_append hd (f x::tl)
  | _, [] -> failwith "index out of bounds"

let run_game
    ?(move_time_ns = 1_000_000_000L)
    ?(state_maker : (int -> Random.State.t) option)
    (configuration : configuration)
    (player_initializer : configuration -> int -> player)
    (apply_move : move_applier)
    (has_won : win_checker)
    (is_valid_move : move_validator)
    (engines : game_engine list)
    : (game_state * game_log) (* initial state * log *)
    =
  let player_count = List.length engines in

  (* random state, one per player *)
  let state_maker = Option.value ~default:(fun _ -> Random.State.make_self_init ()) state_maker in
  let random_states = List.init player_count state_maker in
  let get_random i () = Random.State.float (List.nth random_states i) 1. in

  let start_engine i (Engine (init, mm)) = RunningEngine (init (get_time move_time_ns) (get_random i) configuration, mm) in
  let started_engines = List.mapi start_engine engines in

  let rec impl_run_game running_engines move_stack ({ next_player ; _ } as gst : game_state) =
    (* get all the moves made by other players *)
    let moves_since_last_turn = take_rev (player_count - 1) move_stack in
    let RunningEngine (st, mm) = List.nth running_engines next_player in

    (* run the game engine *)
    let move, st' = mm (get_random next_player) (get_time move_time_ns) configuration moves_since_last_turn st in

    (* the engine made an invalid move *)
    if not @@ is_valid_move configuration gst move then
      InvalidMove (next_player, move)
    else
    let gst' = apply_move configuration gst move in
    MakeMove (next_player, move, gst', lazy (
      (* check if the current player just won *)
      if has_won configuration gst' then
        GameOver next_player
      else
        let running_engines' = update_nth next_player (Fun.const @@ RunningEngine (st', mm)) running_engines in
        impl_run_game
          running_engines'
          (move::move_stack)
          gst')
    )
  in let gst0 = { next_player = 0 ; camels = [] ; players = List.init player_count (player_initializer configuration) }
  in (gst0, impl_run_game started_engines [] gst0)


let pop_if p = function
  | x::xs when p x -> Some x, xs
  | xs -> None, xs

let player_at players pos =
  Option.map fst
  @@ List.find_opt (fun (_, p) -> pos = p.position)
  @@ List.mapi (fun i p -> (i, p)) players

(** Draw a game board using unicode box drawing characters (i.e. not ASCII).
  If [mark] is given, additionally place a marker [c] for every position [p] where [mark p = Some c] and there is no player
  (the marker is [string] to allow for unicode, but should be one (unicode code point) long) *)
let draw_game_board ?(mark : (position -> string option) = Fun.const None) cfg gst =
  let reversed comparator x y = - comparator x y in
  (* sorted: bottom to top, then in each row right to left, then horizontal camels before vertical camels
    sort camels based on the lowest-right end of the camel, horizontal camels before vertical camels
    camel_key has the order reversed (simpler code), then the comparator is reversed for the right ordering *)
  let camel_key = function
    | H (x, y) -> (y + 1, x + 2, 1)
    | V (x, y) -> (y + 2, x + 1, 0)
  in
  let sorted_camels = List.sort (reversed @@ compose2 compare camel_key) gst.camels in

  (* bottom to top, then in each row right to left *)
  let sorted_positions =
    let (>|=) = Fun.flip List.map in
    List.init cfg.board_height Fun.id |> List.rev                       >|= fun y ->
    List.rev_map (fun x -> x, y) (List.init cfg.board_width Fun.id)
  in

  let v_at x y = function V p when p = (x, y) -> true | _ -> false in
  let h_at x y = function H p when p = (x, y) -> true | _ -> false in
  (* go through the rows from bottom to top, then in each row from right to left *)
  let rec impl_draw_game_board rss r1 r2 prev_h next_vs prev_vs ws = function
    | ((x, y)::row)::rows ->
      let open Option in
      (* a horizontal camel below and to the left-below of our position *)
      let h, ws' = pop_if (h_at (x - 1) y) ws in
      (* a vertical camel to the right and right-above of our position *)
      let v, ws'' = pop_if (v_at x (y - 1)) ws' in
      (* a vertical camel to the right and right-below of our position *)
      let prev_v, prev_vs' = pop_if (v_at x y) prev_vs in
      let p_opt = player_at gst.players (x, y) in
      let mark_opt = mark (x, y) in
      let at_bottom_edge = y = cfg.board_height - 1 in
      let at_right_edge = x = cfg.board_width - 1 in
      let r1' =
        " "
        :: fold ~none:(value ~default:" " mark_opt) ~some:string_of_int p_opt
        :: " "
        :: (if is_some v || is_some prev_v then "┃" else if at_right_edge then "│" else " " (* "┊" *) (* "│" *))
        :: r1
      in
      let r2' =
        (if at_bottom_edge then "───" else if is_some h || prev_h then "━━━" else "   " (* "┄┄┄" *) (* "───" *))
        :: (if is_some prev_v then "╂" (* "┃" *) else if prev_h then "┿" (* "━" *) else
            match at_bottom_edge, at_right_edge with true, true -> "╯" | true, false -> "┴" | false, true -> "┤" | _ -> "┼" (* " " *))
        :: r2
      in
      impl_draw_game_board rss r1' r2' (is_some h) (to_list v @ next_vs) prev_vs' ws'' (row::rows)
    | []::rows ->
      let at_bottom_edge = match rss with [] -> true | _ -> false in
      let rss' = (List.map (String.concat "") ["│"::r1; (if at_bottom_edge then "╰" else "├")::r2]) @ rss in
      impl_draw_game_board rss' [] [] false [] (List.rev next_vs) ws rows
    | [] -> String.concat "\n" @@ ("╭" ^ (String.concat "┬" @@ List.init cfg.board_width @@ Fun.const "───") ^ "╮") :: rss
  in
  impl_draw_game_board [] [] [] false [] [] sorted_camels sorted_positions

let string_of_position (x, y) = Printf.sprintf "(%i, %i)" x y

let string_of_camel = function
  | H pos -> "H " ^ string_of_position pos
  | V pos -> "V " ^ string_of_position pos

let string_of_dir = function
  | Up -> "Up"
  | Down -> "Down"
  | Left -> "Left"
  | Right -> "Right"
  | UpLeft -> "UpLeft"
  | UpRight -> "UpRight"
  | DownLeft -> "DownLeft"
  | DownRight -> "DownRight"

let string_of_move = function
  | Camel w -> "Camel (" ^ string_of_camel w ^ ")"
  | Move d -> "Move " ^ string_of_dir d
  

let print_game_res (cfg : configuration) (gst0, log) =
  let print_info n gst =
    prerr_endline @@ "seq " ^ string_of_int n;
    print_endline @@ draw_game_board cfg gst;
  in
  let rec print_game_log n = function
  | MakeMove (p, move, gst, next) ->
    prerr_endline @@ "player " ^ string_of_int p ^ ": " ^ string_of_move move;
    print_info (n + 1) gst;
    if n >= 128 then ()
    else print_game_log (n + 1) @@ Lazy.force next
  | InvalidMove (p, move) ->
    prerr_endline @@ "player " ^ string_of_int p ^ " invalid move: " ^ string_of_move move
  | GameOver p ->
    prerr_endline @@ "player " ^ string_of_int p ^ " wins!"
  in
  print_info 0 gst0;
  print_game_log 0 log

let rec base64 xs =
  let open Int in
  let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" in
  let f1 a = alphabet.[shift_right a 2] in
  let f2 a b = alphabet.[logor (shift_left (logand a 3) 4) (shift_right b 4)] in
  let f3 b c = alphabet.[logor (shift_left (logand b 15) 2) (shift_right c 6)] in
  let f4 c = alphabet.[logand c 63] in
  match xs with
  | [] -> []
  | [a] -> [f1 a; f2 a 0; '='; '=']
  | [a; b] -> [f1 a; f2 a b; f3 b 0; '=']
  | a :: b :: c :: d -> f1 a :: f2 a b :: f3 b c :: f4 c :: base64 d

let prerr_base64 xs = List.iter prerr_char (base64 xs)

let print_game_res_web (cfg : configuration) (_, log) =
  let prerr_move move = prerr_base64 (match move with
      | Move Up -> [0; 0; 0]
      | Move Right -> [0; 1; 0]
      | Move Down -> [0; 2; 0]
      | Move Left -> [0; 3; 0]
      | Move UpLeft -> [0; 4; 0]
      | Move UpRight -> [0; 5; 0]
      | Move DownLeft -> [0; 6; 0]
      | Move DownRight -> [0; 7; 0]
      | Camel (H (a, b)) -> [1; a; b]
      | Camel (V (a, b)) -> [2; a; b]
    );
    flush stderr
  in
  let rec print_game_log = function
    | MakeMove (_, move, _, next) ->
        prerr_move move;
        print_game_log (Lazy.force next)
    | InvalidMove (_, move) -> prerr_move move
    | _ -> ()
  in
  prerr_string "View online: https://crazycaml.pl.cit.tum.de/embed.html#i";
  prerr_base64 [3; cfg.board_width; cfg.board_height];
  flush stderr;
  print_game_log log;
  prerr_newline ()

let two_player_initializer { board_width ; board_height ; starting_camels } player =
  let pos_x = board_width / 2 in
  let pos_y = match player with
    | 0 -> 0
    | 1 -> board_height - 1
    | _ -> failwith "can only initialize two players"
  in { position = (pos_x, pos_y) ; current_camels = starting_camels }
  
let play () =
  let cfg = { board_width = 7 ; board_height = 7 ; starting_camels = 8 } in
  let game = run_game
  cfg
  two_player_initializer
  apply_move
  has_won
  is_valid_move
  [ Engine (get_initial_state, make_move_state) ;
    Engine (get_initial_state, make_move_state) ]
  in
  print_game_res cfg game;
  print_game_res_web cfg game

let _ = play ()

