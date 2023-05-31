# Student Database
In this assignment, you have to manage the students of a university.

1. **Type**  
    First you need to define some types.
    - Define a data type for a ```student```.  
    A student should be represented as a record of the students ```first_name```, ```last_name```, identification number ```id```, number of the current ```semester``` as well as the list of ```grades``` received in different courses.  
    The grades should be a pair of the course number and the grade value, a floating point number.
    - To actually manage student you need a ```database``` which shall be represented as a list of students.
2. **insert**  
    Write a function ```insert : student -> database -> database``` that inserts a student into the database.
3. **find_by_id**  
    Write a function ```find_by_id : int -> database -> student list``` that returns a list with the (first) student with the given id (either a single student or an empty list, if no such student exists).
4. **find_by_last_name**  
    Implement a function ```find_by_last_name : string -> database -> student list``` to find all students with a given last name.