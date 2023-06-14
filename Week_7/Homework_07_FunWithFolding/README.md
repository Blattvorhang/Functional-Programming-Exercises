# Fun with Folding
Consider the higher-order function 
**fold_left**
, which was defined in the lecture and is also \[part of the standard List library module\](https://v2.ocaml.org/api/List.html#VALfold_left). The function 
**fold_left**
 can be used to implement many operations that scan through a list from left to right. It takes three arguments: a function 
 **f**
 , an initial accumulator, and a list. For each element 
 **x**
 in the list, the currect accumulator is combined with **x** to produce the next accumulator value; the result of **fold_left** is the final accumulator value. Consult the lecture slides or the documentation for the precise definition!

In each of the following tasks, define a function **fn**, so that **fold_left fn a xs** has the specified behaviour. Do not pass your **fn** to **fold_left**: the tests will do that for you, with appropriate values for **a** and **xs**.

1. **f1**  
    Define **f1**, such that **fold_left f1 0 l** returns the length of list **l**.

2. **f2**  
    Define **f2**, such that **fold_left f2 \[\] \[$l_1$;$l_2$;$\dots$;$l_n$\]** for $l_i$ being arbitrary lists, returns the longest of those lists. If multiple lists have maximal length, either one may be returned.

3. **f3**  
    Define **f3**, such that **fold_left f3 \[\] \[($a_1$,$b_1$);($a_2$,$b_2$);$\dots$;($a_n$,$b_n$)\]** for arbitrary $a_i,b_i$​ computes **\[($b_1$,$a_1$);($b_2$,$a_2$);$\dots$;($b_n$,$a_n$)\]**.

4. **f4**  
    Define **f4**, such that **fold_left f4 \[\] \[$a_0$;$\dots$;$a_{n-3}$;$a_{n-2}$;$a_{n-1}$;$a_n$\]** for arbitrary elements $a_i,b_i$ computes **\[$a_n$;$a_{n-2}$;$\dots$;$a_0$;$\dots$;$a_{n-3}$;$a_{n-1}$\]**.

5. **f5**  
    Define **f5**, such that  **fold_left f5 (fun _ -> $u$) \[$k_1$,$v_1$;$k_2$,$v_2$;$\dots$;$k_n$,$v_n$\]**, for any arbitrary value $u$, computes a function $g$ such that $g(k_i)=v_i$ for all $1\leq i\leq n$. Assume that the $k_i$ are all distinct: $\forall _{1\leq i<j\leq n} .k_i \ne k_j$.

6. **f6**  
    Define **f6**, such that **fold_left f6 \[$v$\] \[$f_1$;$f_2$;$\dots$;$f_n$\]** computes **\[$f_n(\dots f_2(f_1(v))\dots)$;$\dots$;$f_2(f_1(v))$;$f_1(v)$;$v$\]** for unary functions $f_i$​ and arbitrary $v$.

7. **f7**  
    Define **f7**, such that **fold_left f7 a \[$c_n$;$c_{n-1}$;$\dots$;$c_0$\]** computes $a^{2^{n+1}} * \prod_{i=0}^n c_i^{2^i}$ for integers $a,c_0,\dots,c_n$.