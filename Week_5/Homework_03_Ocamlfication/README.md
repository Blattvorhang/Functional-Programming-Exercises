# OCamlfication
**foo**  
Consider the following function foo implemented in an imperative programming language:

```C++
int foo(int x, int y, bool b) {
    if(x > y) {
        int t = x;
        x = y;
        y = t;
    }
    while(x < y) {
        if(b) {
            ++x;
        } else {
            --y;
        }
        b = !b;
    }
    return x;
}
```

Implement a semantically equivalent function `foo : int -> int -> bool -> int` in OCaml.