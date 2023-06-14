let lagrange set = fun x ->
  let rec poly01 prod j k xj = function
    | [] -> prod
    | (xk,_)::t -> if k = j then poly01 prod j (k+1) xj t
                    else poly01 (prod *. (x -. xk) /. (xj -. xk)) j (k+1) xj t
  in 
  let rec poly sum j = function
    | [] -> sum
    | (xj,yj)::t -> poly (sum +. yj *. (poly01 1. j 0 xj set)) (j+1) t
  in poly 0. 0 set
