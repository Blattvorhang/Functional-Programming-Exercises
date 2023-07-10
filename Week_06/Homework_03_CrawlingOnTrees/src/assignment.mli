type tree = Empty 
          | Node of int * tree * tree
type command = Left | Right | Up | New of int | Delete | Push | Pop


val crawl : command list -> tree -> tree