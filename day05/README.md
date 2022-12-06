**Solution:**

This one is a fun one with a lot of parsing.

The input file can be splitted into two parts, the stacks definition and the move
logs.

The stack definitions can be parsed by chunking each line into a chunk of 3 letters,
like `"[X]"`, or `"<3 spaces>"`. And construct a `stacks` arrays that has each element
is an array of each columns found in the chunked string.

The move log can be parsed int he format of: `move <count> from <start-col> to <end-col>`.

From this point, the rest is just following the moves and manipulate the `stacks`.
