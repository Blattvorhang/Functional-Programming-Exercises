let foo x y b = 
  let rec while_loop x y b =
    if x < y then
      if b then
        while_loop (x + 1) y (not b)
      else
        while_loop x (y - 1) (not b)
    else x
  in
  if x > y then
    while_loop y x b
  else
    while_loop x y b
