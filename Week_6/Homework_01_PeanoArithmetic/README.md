# Peano Arithmetic
The natural numbers can be defined recursively as follows:

- 0 is a natural number.
- if $n$ is a natural number, then so is the successor of $n$

We can easily represent this in OCaml using corresponding constructors:

```Ocaml
type nat = Zero | Succ of nat
```

Implement the following functions for natural numbers:

First convert between integers and naturals in the file `conv.ml`

1. **int_to_nat**  
    `int_to_nat : int -> nat` converts an integer to natural.
2. **nat_to_int**  
    `nat_to_int : nat -> int` converts a natural to integer.

Then implement some operations on naturals in the file `ops.ml`:

1. **add**  
    `add : nat -> nat -> nat` adds two natural numbers.
2. **mul**  
    `mul : nat -> nat -> nat` multiplies two natural numbers.
3. **pow**  
    `pow : nat -> nat -> nat` a call `pow a b` computes $a^b$.
4. **leq**  
    `leq : nat -> nat -> bool` a call `leq a b` computes $a\leq b$

You are not allowed to use integers to implement the operations on naturals!