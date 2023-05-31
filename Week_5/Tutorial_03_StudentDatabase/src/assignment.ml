type student = {
  first_name : string;
  last_name : string;
  id : int;
  semester : int;
  grades : (int * float) list;
}

type database = student list

let insert s db = s::db

let rec find_by_id id db = match db with
  | [] -> []
  | h::t -> if h.id = id then [h] else find_by_id id t

let rec find_by_last_name name db = match db with
  | [] -> []
  | h::t -> if h.last_name = name then h::find_by_last_name name t else find_by_last_name name t
