# Camel Present Factory
Atop a sandstone tower deep within the desert expanse at the heart of Camelia, lives the Deliverer, an OCaml sage whose identity has been lost to time. Once a year, the Deliverer brings to children across the many deserts and oases of Camelia the gifts they wish so desperately for. Owing to the Deliverer's isolated home, surrounded by unforgiving deserts, highly trained camel post delivery people bring letters bearing the wishes of children to the tower.

Gifts are produced by apprentice sages in factories housed within the naturally cool underground caverns beneath the tower. In recent years, many newcomers have moved to Camelia, escaping the imperative ways of neighbouring lands. Now, the Deliverer wants to automate their factories to keep up with the increased demand. For this, they need your help to make sure all the children of Camelia get their wishes fulfilled.

**read_notes**  
During the year, the Deliverer keeps track of all children's behavior by inscribing notes onto sandstone tablets. So your first task is to read the notes into your program such that this information is available. The structure of the inscribed tablets is such that every line contains a child's name and their behavior (either *nice* or *naughty*) separated by a colon.

Implement a function `read_notes : string -> notes` which reads the file with the given name. The `notes` type has the following definition:

```Ocaml
type behavior = Nice | Naughty
type notes = (string * behavior) list
```

If this function encounters an invalid entry while reading the file, the exception

```Ocaml
exception Invalid_file_format of string
```

has to be thrown with the invalid file's name as the argument. We consider an entry invalid if it does not stick to the form *name:behavior* where *name* is a non-empty string not containing any colons or newlines and *behavior* is either *nice* or *naughty*.  
The restrictions on the name also apply for the string parts in the next two tasks.

---

**read_wishlist**  
The most time-consuming part of the Deliverer's working day is reading all the wish lists under the hot desert sun. Luckily, over the last years, the Deliverer trained all children to write their wish lists in such a way that every line has the form *wish:importance*, where *wish* is simply the name of one toy and *importance* is a value between $1$ and $100$ that gives the Deliverer a hint on how desperately the child wants to have this present.  
Write a function `read_wishlist : string -> (string * int) list` that reads the wish list with the given file name. Again throw an `Invalid_file_format` exception if any entry is not valid.

---

**load_catalogue**  
Like every year, the Deliverer asks their many helper sages to write down all toys that are available in the current year in a large catalogue. There is no harm in loading this catalogue into your program as well. Every entry in the catalogue file is of the form *toy:weight* where *weight* is a positive integer weight of the *toy* that the Deliverer needs to know to prevent the overload of their delivery camels.
Implement a function `load_catalogue : string -> (string * int) list` that reads the given file and again throws an `Invalid_file_format` exception if there is something wrong with the file.

---

**write_list**  
The next thing to do is to give the Deliverer a means to print a list of presents they have chosen for a child, so that their helpers can load everything onto the camels. Implement the function `write_list : string -> string list -> unit` that stores the list of selected presents (2nd argument) into a file (1st argument).

---

**write_letter**  
Lastly, all naughty kids do not receive any presents. Instead, the Deliverer sends them a letter telling them that they have to be more polite and stick to their programming exercises to receive any presents next year. Being old and tired, the Deliverer does not like having to greet, write over 50 characters of encouragements and then sign each letter for so many naughty children, so this really needs to be automated. Implement the function `write_letter : string -> unit` that writes such a letter into the file with the given name.
The given filename is in the format 
**"letters/**$name$**.txt"**. The Deliverer doesn't mind too much if you write the same letter for everyone but is willing to give you a little extra if you can manage personalized letters by greeting each child by name (but not by filename).

---

**run_desert_factory**  
Now everything is together to run the present factory in the desert. Implement the function `run_desert_factory : int -> selection_alg -> unit` that performs the following tasks:

- Load the toy catalogue from the file **"toys_catalogue.txt"**.

- Read the Deliverer's notes from the file **"deliverers_notes.txt"**.

- For every naughty child name write a letter to the file **"letters/**$name$**.txt"**.

- For every nice child name:

    - Read the child's wish list from the file **"wishlists/**$name$**.txt"**.

    - Construct a `(string * int * int) list` which has an entry (toy,importance,weight) for all the child's wishes, where the first two parts are taken from the wish list and the weight is checked in the catalogue. Toys on the child's wish list that are not available (in the catalogue) have to be removed from the list.

    - Pass this list to the present selection algorithm, together with the delivery camels' capacity (passed as the 2nd and 1st argument to `run_desert_factory`).
        
        ```Ocaml
        type selection_alg = (string * int * int) list -> int -> string list
        ```
    
    - Write the selected presents to the file **"presents/**$name$**.txt"** one per line.

Errors are handled in the following way: If a child's wish list is invalid, that child is simply ignored and everyone else still has to get their presents! All other exceptions are not handled inside `run_desert_factory`.

---

**Bonus: knapsack**  
Implement the function `knapsack : (string * int * int) list -> int -> string list` as a possible present selection algorithm. The function has to find an optimal selection of presents from the list (1st argument) such that the total weight is less than or equal to the capacity of the delivery camels (2nd argument) and that the sum of *importance* of all selected presents is maximal.

---

*Hint: First, read all tasks of this assignment carefully, as you may identify common functionality that may be reused in different places.*

*Hint: Assume that everything is always in the same case. No need to care about case-insensitive comparison.*  
*Hint: Make sure to always close all opened files (even in case of exceptions)!*  
*Hint: Remember that all IO operations can fail and throw some exception.*  
*Hint: Check the OCaml String documentation for the function `split_on_char`.*  
*Hint: Use the function `int_of_string` to convert a string to an integer. Be aware that this function may throw an exception. Check the documentation.*  
*Hint: If you fail the `xxx (exn)` tests but pass the others, check your exception handling for that exercise.*

---

*Note: For this exercise, all IO functions in the `Stdlib` and the modules `Format`, `Printf` and `Scanf` are available for use.*