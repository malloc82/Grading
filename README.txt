Thoughts:

- list vs structure:
  list is very flexible, but messy; 
  - I could change a file or add a field quite easily, at the same time, when I want to know what field
    a particular list has, I will have to look through code.
    This could be made easier to have a function initialize all the fields needed. But then if there is 
    a typo somewhere else, it would be hard to find, cuz there would be no error. This probably could be 
    eliminated by incremental testing. 

  - structure could be used to capture compile time error. If you are wondering what feature a structre has
    there is only one place to look up. But it would be hard to modify the design sometimes, cuz there are 
    multiple places need to change. Iterating through all the attributes are difficult. More static.

  Design should be list of objects not object contains lists.

- Lookup tables:
  Two lookup tables are used to keep track of duplicates. 
  They are used to handle simplified input from users, such as only enter either first name or last name
  for a student or a group of students. 
  It could be resolved without these two tables by searching through grade-table, but it could be too
  inefficient.
  The flip side of this is that there is not too many students in a course (~60 max), so the overall 
  performance gain will be trivial.

- Macro:
  
