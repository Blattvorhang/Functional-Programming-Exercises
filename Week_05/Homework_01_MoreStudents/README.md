# More Students!
In this assignment you will extend the student database introduced in [W05T03](../Tutorial_03_StudentDatabase/). All type definitions and functions developed in W05T03 are already in the template.

Implement these new functions:

1. remove_by_id  
    ```remove_by_id : int -> database -> database``` removes the student with the given id from the database.
2. count_in_semester  
    ```count_in_semester : int -> database -> int``` counts the number of students in the given semester.
3. student_avg_grade  
    ```student_avg_grade : int -> database -> float``` computes the average grade of the student with the given id. If no student with the given id exists or the student does not have any grades, the function shall return 0.0.
4. course_avg_grade  
    ```course_avg_grade : int -> database -> float``` computes the average grade achieved in the given course. If no grades in the given course exist, the function shall return ```0.0```.