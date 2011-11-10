Thoughts:

- list vs structure:
  list is very flexible, but messy; structure could be used to capture compile time error. 
  Design should be list of objects not object contains lists.
  Iterating through lists may not be very efficient, but if the iteration is   

- Lookup tables:
  Two lookup tables are used to keep track of duplicates. 
  They are used to handle simplified input from users, such as only enter either first name or last name
  for a student or a group of students. 
  It could be resolved without these two tables by searching through grade-table, but it could be too
  inefficient.
  The flip side of this is that there is not too many students in a course (~60 max), so the overall 
  performance gain will be trivial.

- Macro:
  
