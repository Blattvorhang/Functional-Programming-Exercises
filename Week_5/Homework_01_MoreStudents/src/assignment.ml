(* Existing definitions from tutorial assignments *)
type student = {
  first_name : string;
  last_name : string;
  id : int;
  semester : int;
  grades : (int * float) list;
}

type database = student list

let insert s db = s::db

let rec find_by_id id db = match db with [] -> []
  | x::xs -> if x.id = id then [x] else find_by_id id xs

let rec find_by_last_name name db = match db with [] -> []
  | x::xs -> if x.last_name = name
    then x::find_by_last_name name xs
    else find_by_last_name name xs

(*****************************************************************************)
let rec remove_by_id id db = match db with [] -> []
  | x::xs -> if x.id = id then remove_by_id id xs else x::remove_by_id id xs

let rec count_in_semester sem db = match db with [] -> 0
  | x::xs -> if x.semester = sem then 1 + count_in_semester sem xs else count_in_semester sem xs

let rec student_avg_grade id db = match db with [] -> 0.0
  | x::xs -> if x.id = id then (* assume that id is unique *)
      let rec sum_grades grades = match grades with [] -> 0.0
        | (number, value)::ys -> value +. sum_grades ys
      in
      let rec count_grades grades = match grades with [] -> 0
        | (number, value)::ys -> 1 + count_grades ys
      in
      let (sum, count) = (sum_grades x.grades, count_grades x.grades) in
      if count = 0 then 0.0 else sum /. (float_of_int count)
    else student_avg_grade id xs

let course_avg_grade course db =
  (* assume that each student has no more than one course with the same number *)
  (*
  let rec sum_grades course db = match db with [] -> 0.0
    | x::xs -> let rec find_grade course grades = match grades with [] -> 0.0
      | (number, value)::ys -> if number = course then value else find_grade course ys
    in
    (find_grade course x.grades) +. sum_grades course xs
  in
  let rec count_grades course db = match db with [] -> 0
    | x::xs -> let rec find_grade course grades = match grades with [] -> 0
      | (number, value)::ys -> if number = course then 1 else find_grade course ys
    in
    (find_grade course x.grades) + count_grades course xs
  in
  let (sum, count) = (sum_grades course db, count_grades course db) in
  if count = 0 then 0.0 else sum /. (float_of_int count)
  *)

  (* optimized *)
  let rec avg_grade_count_sum course db count sum = match db with [] -> (count, sum)
    | student::xs ->
      let rec find_grade course grades = match grades with [] -> (0, 0.0)
        | (number, value)::ys ->
          if number = course then (1, value)
          else find_grade course ys
      in
      let count', sum' = find_grade course student.grades in
      avg_grade_count_sum course xs (count + count') (sum +. sum')
  in
  let count, sum = avg_grade_count_sum course db 0 0.0 in
  if count = 0 then 0.0
  else sum /. (float_of_int count)