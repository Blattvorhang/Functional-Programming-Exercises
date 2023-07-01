# Polynomial Party
A polynomial

$$
c_n x^n + c_{n-1} x^{n-1} + \dots +c_2 x^2 + c_1 x + c_0
$$

is represented by the list $[c_n;c_{n-1};\dots;c_2;c_1;c_0]$ of its coefficients.

1. **eval_poly**  
    Implement `eval_poly : float -> float list -> float` that evaluates the polynomial (2. argument) for a given $x$ (1. argument).
2. **derive_poly**  
    Implement `derive_poly : float list -> float list` that returns the first derivative of the given polynomial.