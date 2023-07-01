type student = {
  first_name : string;
  last_name : string;
  id : int;
  semester : int;
  grades : (int * float) list;
}

type database = student list

val remove_by_id : int -> database -> database

val count_in_semester : int -> database -> int

val student_avg_grade : int -> database -> float

val course_avg_grade : int -> database -> float