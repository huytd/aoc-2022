**Solution:**

My code for today's challenge is a mess :pensive:

Yet another fun parsing problem, and the approach is to create a tree data structure
that simulates the file system, then check the input line by line. At each line:

- If it has the format of `$ cd <folder>`, move the `head` pointer to the target folder.
- To handle the `cd ..` case, each `Dir` node will have a pointer to its parent.
- If it has the format of `$ ls` then start reading the next lines until another command
(`$ ...`) is found.

The rest is just tree traversal.
