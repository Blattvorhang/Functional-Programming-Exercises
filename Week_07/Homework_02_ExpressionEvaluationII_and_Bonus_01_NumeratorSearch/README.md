# Expression Evaluation II
In this assignment you will extend the expression evaluation of [Week 06 Homework 02 — Expression Evaluation](../../Week_06/Homework_02_ExpressionEvaluation/). We extend our expression language as follows:

```ocaml
type rat = int * int                                    (* numerator, denominator *)
type var = string                                       (* new *)
type unary_op = Neg
type binary_op = Add | Sub | Mul | Div
type expr = Const of rat
          | UnOp of unary_op * expr
          | BinOp of binary_op * expr * expr
          | Var of var                                  (* new *)
          | Func of var * expr                          (* new *)
          | Bind of var * expr * expr                   (* new *)
          | App of expr * expr                          (* new *)
          | Ite of expr * expr * expr                   (* new *)
type value = Rat of rat | Fun of var * state * expr     (* new *)
and state = var -> value option                         (* new *)
```
Here, we have first introduced 5 new forms of expressions:

- `Var x` simply represents a variable with name `x` in an expression. Example: An expression $i+\frac{1}{3}$ is now represented as
    ```ocaml
    BinOp (Add, Var "i", Const (1, 3))
    ```

- `Ite (c, t, e)` represents an expression `if c then t else e`, where `c` is the condition and `t` and `e` are the expressions in the $then$- and $else$-branches, respectively. Note, that our language does not contain a `bool` type, so we consider a condition as `false` if and only if the value `c` is equal to $0$ (e.g. $\frac{0​}{3},\frac{{0}}{8},\dots$)

- `Bind (x, e, b)` binds the value of expression `e` to the variable named `x` inside the expression `b`. All bindings are non-recursive. Example: An expression like `let t = 2/3 * i in t` can be represented by
    ```ocaml
    Bind ("t", BinOp (Mul, Const (2, 3), Var "i"), Var "t")
    ```

- `Func (a, b)` is the definition of a unary function with argument `a` and function body `b`. Example: The expression `fun y -> 2 - y` is represented by
    ```ocaml
    Func ("y", BinOp (Sub, Const (2,1), Var "y"))
    ```

- `App (f, a)` is the application of the function produced by expression `f` to argument `a`. Note that both `f` and `a` may be arbitrarily complex. Example: `(foo i) (1/2 - 2/7)` is represented by
    ```ocaml
    App (App (Var "foo", Var "i"), BinOp (Sub, Const (1,2), Const (2,7)))
    ```

Next, in addition to rationals, expressions can now also evaluate to functions. Therefore we have defined the `value` type where `Rat` represents a rational (as before) and `Fun (a, s, b)` represents a function with argument `a`, body `b` and captured state `s`. Like in OCaml, the values of variables inside a function (except for the function's arguments) are determined when the function is defined, not when it is called. Thus, a function value needs to store the state of variables in `s`.

Finally, we define such a `state` as a mapping from variable names to `value option`, such that the value of a variable is `None`, if is has not been defined yet.

**eval_expr**  
Extend the function `eval_expr : state -> expr -> value` to support these new features. Note, that the type of `eval_expr` is adapted accordingly: A `state`, which is the current mapping of variables to values, is passed as the first argument and `eval_expr` now returns a `value`, since an expression may no longer only evaluate to a rational.

The same requirements for reducing intermediate and final results apply as in [Week 06 Homework 02 — Expression Evaluation](../../Week_06/Homework_02_ExpressionEvaluation/).

*Hint: The template `assignment.ml` already contains a pretty-printing function `string_of_expr`.*  
*Hint: The template contains an adapted version of `eval_expr` from the Week 06 Homework 02 sample solution that you may use in your submission, if you would like.*  

### Notation and printing
<details>
    <summary mardown="span">Click to show section</summary>

The remaining examples, as well as the output of the tests, represent `expr` values in a more readable form. Click the λ on code blocks in this exercise to switch to a more mathematical notation. If the output of a test is unclear to you, you may enable more verbose output by setting the value `pretty_print_mode` in your submission:
- `0` (default): fully prettified (like the examples below)
- `1`: prettified but with all brackets
- `2`: as OCaml expressions (like the examples above)

The function `string_of_expr` included in the template also implements a printer similar to mode `0`, use it to test and debug your submission! Our hope is that the prettified outputs allow you to get a better understanding of your code.

The prettified representation of an `expr` value is as follows:

- For constant/rational expressions, e.g. `Const (3, 5)`:
    ```
    (3/5)
    ```
- For unary operations, e.g. `UnOp (Neg, Var "x")`:
    ```
    - x
    ```
- For binary operations, e.g. `BinOp (Add, BinOp (Sub, Var "x", Const (-1, 7)), Var "y")`:
x - (-1/7) + y
As in the example above, if brackets are left out, operations are grouped starting from the left (i.e. binary operators are printed as left-associative).

For example, for `BinOp (Sub, Var "x", BinOp(Add, Const (-1, 7), Var "y"))` the representation would instead be:

x - ((-1/7) + y)
- For variables, e.g. `Var "x"`:
x
- For function definitions, e.g. Func ("x", BinOp (Add, Var "x", Const (1, 1))):
fun x -> x + (1/1)
For local binds, e.g. Bind ("f", Func ("x", UnOp (Neg, Var "x")), App (Var "f", Const (-3, 2))):
let f = fun x -> - x in f (-3/2)
For function application, e.g. App (Var "f", Var "x"):
f x
For if-then-else statements, e.g. Ite (Var "x", Var "y", Var "z"):
if x then y else z


</details>

### Restrictions on test inputs
<details>
    <summary mardown="span">Click to show section</summary>

</details>

### Examples
<details>
    <summary mardown="span">Click to expand section</summary>

</details>

## Numerator Search (Bonus Exercise)
*This part of the exercise (i.e. the numerator search) is a bonus exercise; it is not relevant for solving the main exercise and will not be relevant for the exam. This bonus exercise is significantly more difficult than other exercises: last year, there were only seven valid submissions.*

### Task Description (Informal)
**Numerator Search**  
Your task is to find a function `f`, such that when it is applied to a rational and evaluated, yields the numerator of the reduced representation of that rational. For negative rationals, the result should be negative, otherwise, it should be positive. The numerator `n` should be returned as `Rat (n, 1)`.

For the tests, set `numerator = Some f`.

### Formal Task Description
<details>
    <summary mardown="span">Click to show formal definition</summary>

Let $\frac{n}{d} \in \mathbb{Q}$ where $gcd(n, d)=1$ and $d>0$.

The template defines `numerator : expr option = None`. Change `numerator` to `Some f`, such that:

For all $k \in \mathbb{Z}\ \backslash \ {0}$ where $n':=k\cdot n$ and $d':=k\cdot d$ are representable as OCaml `int`s:

`eval_expr st (App (f, Const (n', d'))) = Rat (n, 1)`

for any state `st`.

</details>

The remaining hints will help you if you get stuck! Try to get as far as you can on your own though.

<details>
    <summary mardown="span">Hint 1</summary>

Last week's expressions were plain and bland. For any given expression, there were a finite number of steps we had to take before we arrived at a result. As part of his investigation into the foundations of mathematics in the 1930s, Alonzo Church discovered and presented the so-called [*lambda-calculus*](https://en.wikipedia.org/wiki/Lambda_calculus). The *lambda-calculus* also consists only of finite expressions, but they can represent any computable function! In fact, it is one of *the definitions* of computable functions, along with Turing's Turing machines, Schönfinkel and Curry's combinatory logic, and Markov's Markov algorithms (and more!). The expressions we have defined this week are fun and exciting, because they share many similarites with the expressions of lambda calculus. Our way of evaluating expressions, much like in lambda calculus, allows us to evaluate any computable function!

<details>
    <summary mardown="span">Hint 2</summary>

The exercise explicitly forbids any sort of recursive definition. Lambda calculus also has no notion of recursion, because all functions are *anonymous*: they are defined where they are used as lambda-expressions.

Because we still need recursion sometimes, we can use [*fixed-point combinators*](https://en.wikipedia.org/wiki/Fixed-point_combinator), which are functions that apply a function to itself in a clever way to allow for (a form of) recursion.

The typical Y-Combinator won't work, because our expressions are strict. Instead, find a combinator that will work for strict programming lanugages.

<details>
    <summary mardown="span">Hint 2.1: Alternative to Y-Combinator</summary>

The [*Z-Combinator*](https://en.wikipedia.org/wiki/Fixed-point_combinator#Strict_fixed-point_combinator) will do the trick. Here is a definition as one of our `expr`essions:

<details>
    <summary mardown="span">Hint 2.2: The Z-Combinator</summary>

```ocaml
fun f -> let g = fun x -> f fun v -> x x v in g g
```
*Hint: like all examples on this page (except those in the first section) the above is not actually an OCaml expression, but a pretty-printed `expr` value. Trying to use the above as an OCaml expression will result in a type error; a work-around is given in the linked Wikipedia article.*

</details> <!-- Hint 2.2 -->

</details> <!-- Hint 2.1 -->

<details>
    <summary mardown="span">Hint 3</summary>

As you might have guessed, your solution needs to be recursive in some way. Not sure how to use the Z-Combinator?

Here is an example defining the factorial function (for inputs where the denominator is 1, and the numerator is non-negative, i.e. $\text{N}_0$ ).

```ocaml
let z = fun f -> let g = fun x -> f fun v -> x x v in g g in
let equal = fun x -> fun y -> if x - y then (0/1) else (1/1) in
let f =
  fun self -> fun n -> if equal n (0/1) then (1/1) else n * self (n - (1/1))
in
z f
```
Note that the above definition is *curried*. We could rewrite the last line as:
```ocaml
fun r -> z f r
```
to be more explicit about defining a function that takes one input and returns the value of some `v f r`.

<details>
    <summary mardown="span">Hint 4</summary>

You have no way of comparing the sizes of rationals, but you do have a way of checking if two rationals are equal:
```ocaml
fun x -> fun y -> if x - y then (0/1) else (1/1)
```
The rest is up to you! Good luck!

</details> <!-- Hint 4 -->

</details> <!-- Hint 3 -->

</details> <!-- Hint 2 -->

</details> <!-- Hint 1 -->