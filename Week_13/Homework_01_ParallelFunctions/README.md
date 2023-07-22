# Parallel Functions
In this exercise, we want to implement concurrency for some generic functions, where there are multiple functions, or multiple values to which the function should be applied. In particular, perform the following tasks:

1. **par_app2**  
    Implement a function `par_app2 : ('a -> 'b) -> ('c -> 'd) -> 'a -> 'c -> 'b * 'd`. The call `par_app2 f g x y` returns `(f x, g y)`, but the application of `f` to `x` and the application of `g` to `y` are processed in parallel (each application in its own thread).
2. **par_map**  
    Implement a function `par_map : ('a -> 'b) -> 'a list -> 'b list`. The call `par_map f xs` returns the same result as `List.map f xs`, but all applications of `f` to an argument from `xs` are processed in parallel (each application in its own thread). In other words, `par_map f` returns a new function, that when applied to a list of inputs, applies `f` to each input in parallel (each in its own thread), then returns a list of the results in the same order as the input list.

### Example
```ocaml
let inc = par_map (fun x -> x + 1) in
let both f x y = par_app2 f f x y in
both inc [1;2;3] [4;5;6]
(* computes ([2;3;4], [5;6;7]) *)
```

### Timeouts
To test that your implementation is correct, we use functions that will cause a deadlock if each application is not run in its own thread. If a test times out, it is likely due to such a deadlock. Ensure that, where required, each application of a function happens in its own thread!
