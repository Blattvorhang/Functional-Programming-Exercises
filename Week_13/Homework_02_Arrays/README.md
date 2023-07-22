# Arrays
Recall the idea of the memory cell introduced in the lecture, that runs in its own thread, and communicates to other threads via channels. In this exercise, you will implement a similar behavior that again relies on the communication between threads via channels, but now the use case are arrays instead of single memory cells. To this end, implement a module `Array` with a suitable type `t` and these functions:

1. **make**  
    `make : int -> 'a -> 'a t` that creates an array with given size. All elements are initialized with the given value. This function must start a thread that can handle the requests it receives.
2. **destroy**  
    `destroy : 'a t -> unit` that cleans up the array by stopping the array thread.
3. **size**  
    `size : 'a t -> int` returns the size of the array.
4. **get**  
    `get : int -> 'a t -> 'a` retrieves the entry at the given position. If the position is out of the array’s bounds, throw an OutOfBounds exception.
5. **set**  
    `set : int -> 'a -> 'a t -> unit` updates the entry at the given position with the given value. If the position is out of the array’s bounds, throw an Out_of_bounds exception.
6. **resize**  
    `resize : int -> 'a -> 'a t -> unit` resizes the array to the new given size. If the new size is less than the old size, the superfluous elements are chopped off, while the rest stays unchanged. If the new size is greater than the old size, the new elements are appended and initialized with the given value.

A timeout in the `destroy` test means not all threads are stopped. Due to the nature of this exercise, it is not possible to independently test the single functions. Tests for `destroy`, `size`, `set`, `get` and `resize` all use `make`, the tests for `set` and `resize` use `get` and the test for `resize` also uses size.

Make sure to test your methods!