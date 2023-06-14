# Fun with Folding
Consider the higher-order function 
<span style="font-family: Consolas; font-size: 18px;">fold_left</span>
, which was defined in the lecture and is also [part of the standard List library module](https://v2.ocaml.org/api/List.html#VALfold_left). The function 
<span style="font-family: Consolas; font-size: 18px;">fold_left</span>
 can be used to implement many operations that scan through a list from left to right. It takes three arguments: a function 
 <span style="font-family: Consolas; font-size: 18px;">f</span>
 , an initial accumulator, and a list. For each element 
 <span style="font-family: Consolas; font-size: 18px;">x</span>
 in the list, the currect accumulator is combined with <span style="font-family: Consolas; font-size: 18px;">x</span> to produce the next accumulator value; the result of <span style="font-family: Consolas; font-size: 18px;">fold_left</span> is the final accumulator value. Consult the lecture slides or the documentation for the precise definition!

In each of the following tasks, define a function <span style="font-family: Consolas; font-size: 18px;">fn</span>, so that <span style="font-family: Consolas; font-size: 18px;">fold_left fn a xs</span> has the specified behaviour. Do not pass your <span style="font-family: Consolas; font-size: 18px;">fn</span> to <span style="font-family: Consolas; font-size: 18px;">fold_left</span>: the tests will do that for you, with appropriate values for <span style="font-family: Consolas; font-size: 18px;">a</span> and <span style="font-family: Consolas; font-size: 18px;">xs</span>.

1. **f1**  
    Define <span style="font-family: Consolas; font-size: 18px;">f1</span>, such that <span style="font-family: Consolas; font-size: 18px;">fold_left f1 0 l</span> returns the length of list <span style="font-family: Consolas; font-size: 18px;">l</span>.

2. **f2**  
    Define <span style="font-family: Consolas; font-size: 18px;">f2</span>, such that <span style="font-family: Consolas; font-size: 18px;">fold_left f2 [] [$l_1$;$l_2$;$\dots$;$l_n$]</span> for $l_i$ being arbitrary lists, returns the longest of those lists. If multiple lists have maximal length, either one may be returned.

3. **f3**  
    Define <span style="font-family: Consolas; font-size: 18px;">f3</span>, such that <span style="font-family: Consolas; font-size: 18px;">fold_left f3 [] [($a_1$,$b_1$);($a_2$,$b_2$);$\dots$;($a_n$,$b_n$)]</span> for arbitrary $a_i,b_i$​ computes <span style="font-family: Consolas; font-size: 18px;">[($b_1$,$a_1$);($b_2$,$a_2$);$\dots$;($b_n$,$a_n$)]</span>.

4. **f4**  
    Define <span style="font-family: Consolas; font-size: 18px;">f4</span>, such that <span style="font-family: Consolas; font-size: 18px;">fold_left f4 [] [$a_0$;$\dots$;$a_{n-3}$;$a_{n-2}$;$a_{n-1}$;$a_n$]</span> for arbitrary elements $a_i,b_i$ computes <span style="font-family: Consolas; font-size: 18px;">[$a_n$;$a_{n-2}$;$\dots$;$a_0$;$\dots$;$a_{n-3}$;$a_{n-1}$]</span>.

5. **f5**  
    Define <span style="font-family: Consolas; font-size: 18px;">f5</span>, such that  <span style="font-family: Consolas; font-size: 18px;">fold_left f5 (fun _ -> $u$) [$k_1$,$v_1$;$k_2$,$v_2$;$\dots$;$k_n$,$v_n$]</span>, for any arbitrary value $u$, computes a function $g$ such that $g(k_i)=v_i$ for all $1\leq i\leq n$. Assume that the $k_i$ are all distinct: $\forall _{1\leq i<j\leq n} .k_i \ne k_j$.

6. **f6**  
    Define <span style="font-family: Consolas; font-size: 18px;">f6</span>, such that <span style="font-family: Consolas; font-size: 18px;">fold_left f6 [$v$] [$f_1$;$f_2$;$\dots$;$f_n$]</span> computes <span style="font-family: Consolas; font-size: 18px;">[$f_n(\dots f_2(f_1(v))\dots)$;$\dots$;$f_2(f_1(v))$;$f_1(v)$;$v$]</span> for unary functions $f_i$​ and arbitrary $v$.

7. **f7**  
    Define <span style="font-family: Consolas; font-size: 18px;">f7</span>, such that <span style="font-family: Consolas; font-size: 18px;">fold_left f7 a [$c_n$;$c_{n-1}$;$\dots$;$c_0$]</span> computes $a^{2^{n+1}} * \prod_{i=0}^n c_i^{2^i}$ for integers $a,c_0,\dots,c_n$.