**Solution:**

Today is another solution where you can parameterize the Part 1's implementation
and use it to solve Part 2.

The most important detail when handling the knots is the order for the knots to
follow each other, `knot[i]` will follow the `knot[i-1]`.
