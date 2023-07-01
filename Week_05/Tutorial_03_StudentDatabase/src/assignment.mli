type student = {
  first_name : string;
  last_name : string;
  id : int;
  semester : int;
  grades : (int * float) list;
}

type database = student list

val insert : student -> database -> database

val find_by_id : int -> database -> student list

val find_by_last_name : string -> database -> student list
