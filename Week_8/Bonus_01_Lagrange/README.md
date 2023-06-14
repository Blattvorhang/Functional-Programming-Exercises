# Lagrange
Given a set of points, polynomial interpolation is the task of finding a polynomial with lowest degree that passes through all the points. Assume the set $(x_0, y_0), \dots, (x_n, y_n)$ of points. Then a suitable polynomial is given by

$$
L(x):=\sum_{j=0}^n y_j l_j (x)
$$

where the Lagrange polynomials $l_j (x)$ are defined as follows:

$$
l_j (x):=\prod_{0\leq k\leq n \land k \ne j} \frac{x-x_k}{x_j-x_k}
$$

1. **lagrange**  
    Implement the function `lagrange : (float * float) list -> (float -> float)` that returns the interpolated polynomial $L$.