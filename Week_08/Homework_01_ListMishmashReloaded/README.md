# List Mishmash Reloaded
**interleave3**  
In [Week 05 Homework 02](../../Week_5/Homework_02_ListMishmash/) you implemented a function `interleave3 : 'a list -> 'a list -> 'a list -> 'a list`.  
Implement a tail recursive version of this function. In particular, your function must only use constant stack space.

*Hint: `xs @ ys`, for example, is not tail-recursive and uses stack space in* $\mathcal{O}(\mathrm{length\enspace xs})$