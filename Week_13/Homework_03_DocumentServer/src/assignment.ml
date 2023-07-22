open Thread
open Event

exception Invalid_operation of string

type op =
  | Publish of string * string * string * int channel
  | Change_owner of string * string * int * string * bool channel
  | View of string * string * int * string option channel
  | Add_account of string * string * bool channel
  | Add_viewer of string * string * int * string * bool channel
type t = op channel

type user = string (* username *)
type account = user * string (* username, password *)
type doc = int * string * user * user list (* id, content, owner, viewers *)


(* let string_of_accounts accounts =
  let rec aux = function
    | [] -> ""
    | (u, p) :: accounts -> u ^ " " ^ p ^ "\n" ^ aux accounts
  in
  aux accounts

let string_of_docs docs =
  let rec aux = function
    | [] -> ""
    | (id, content, owner, viewers) :: docs ->
      string_of_int id ^ " " ^ content ^ " " ^ owner ^ " " ^
      (List.fold_left (fun acc viewer -> acc ^ viewer ^ " ") "" viewers) ^ "\n" ^ aux docs
  in
  aux docs *)

let document_server () =
  let server_channel = new_channel () in
  let rec authenticate (u : user) (p : string) = function
    | [] -> false
    | (u', p') :: accounts -> if u = u' then p = p' else authenticate u p accounts
  in
  let rec is_user_exists (u : user) = function
    | [] -> false
    | (u', _) :: accounts -> if u = u' then true else is_user_exists u accounts
  in
  let rec serve (accounts : account list) (docs : doc list) (id_assigner : int) =
    match sync (receive server_channel) with
    | Publish (u, p, doc_cont, c) ->
      if authenticate u p accounts then
        let id = id_assigner in
        let _ = sync (send c id) in
        serve accounts ((id, doc_cont, u, []) :: docs) (id_assigner + 1)
      else
        let _ = sync (send c (-1)) in
        serve accounts docs id_assigner
    | Change_owner (u, p, id, new_owner, c) ->
      if authenticate u p accounts && is_user_exists new_owner accounts then
        if List.exists (fun (id', _, owner', _) -> id = id' && u = owner') docs then
          let new_docs = List.map (fun (id', content', owner', viewers') ->
            if id = id' then (id', content', new_owner, viewers')
            else (id', content', owner', viewers')) docs 
          in
          let _ = sync (send c true) in
          serve accounts new_docs id_assigner
        else
          sync (send c false)
      else
        sync (send c false);
      serve accounts docs id_assigner  (* Side-effect *)
    | View (u, p, id, c) ->
      if authenticate u p accounts then
        match List.find_opt (fun (id', _, _, _) -> id = id') docs with
        | None -> sync (send c None)
        | Some (_, content, owner, viewers) ->
          if u = owner || List.exists (fun viewer -> viewer = u) viewers then
            sync (send c (Some content))
          else
            sync (send c None)
      else
        sync (send c None);
      serve accounts docs id_assigner  (* Side-effect *)
    | Add_account (u, p, c) ->
      if List.exists (fun (u', _) -> u = u') accounts then
        let _ = sync (send c false) in
        serve accounts docs id_assigner
      else
        let _ = sync (send c true) in
        serve ((u, p) :: accounts) docs id_assigner
    | Add_viewer (u, p, id, viewer, c) ->
      if authenticate u p accounts && is_user_exists viewer accounts then
        if List.exists (fun (id', _, owner', _) -> id = id' && u = owner') docs then
          let _ = sync (send c true) in
          let new_docs = List.map (fun (id', content', owner', viewers') ->
            if id = id' then (id', content', owner', viewer :: viewers')
            else (id', content', owner', viewers')) docs
          in
          serve accounts new_docs id_assigner
        else
          sync (send c false)
      else
        sync (send c false);
      serve accounts docs id_assigner  (* Side-effect *)
  in
  let _ = create (serve [] []) 0 in
  server_channel

let publish u p doc s =
  let reply = new_channel () in
  sync (send s (Publish (u, p, doc, reply)));
  let id = sync (receive reply) in
  if id = -1 then raise (Invalid_operation "Invalid username or password.")
  else id

let change_owner u p id owner s =
  let reply = new_channel () in
  sync (send s (Change_owner (u, p, id, owner, reply)));
  let is_valid = sync (receive reply) in
  if is_valid then ()
  else raise (Invalid_operation "Invalid username or password, or user or document does not exists, or the method is not called by the owner.")

let view u p id s =
  let reply = new_channel () in
  sync (send s (View (u, p, id, reply)));
  match sync (receive reply) with
  | None -> raise (Invalid_operation "Invalid username, password or document id, or user is not allowed to view the document.")
  | Some doc -> doc

let add_account u p s = 
  let reply = new_channel () in
  sync (send s (Add_account (u, p, reply)));
  let is_valid = sync (receive reply) in
  if is_valid then ()
  else raise (Invalid_operation "User already exists.")

let add_viewer u p id viewer s =
  let reply = new_channel () in
  sync (send s (Add_viewer (u, p, id, viewer, reply)));
  let is_valid = sync (receive reply) in
  if is_valid then ()
  else raise (Invalid_operation "Invalid username or password, or document or viewer does not exist.")
