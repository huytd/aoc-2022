**Journey**

My initial intent is to create an anonymous function for the opreation, this can be
done like:

```zig
const Monkey = struct {
    ...
    operator: *const fn (i32) i32,
    ...
};
```

And later on, the function can be passed with:

```zig
const mo = Monkey {
    ...
    operator: struct {
        fn calc(input: i32) i32 {
            return input + 5
        }
    }.calc,
    ...
}
```

But I struggled to figure out how to deal with the case where the operand is `old` itself.

Then, I continue to struggle with a stupid mistake when iterating slices, I didn't know that
iterating using `for` will create a copy of the slice's element:

```zig
for (monkeys) |monkey| {
    // mutating monkey will not work
    _ = monkey.takeFirstItem();
}
```

To mutate each item while iterating, we have to get the reference of it:

```zig
for (monkeys) |monkey| {
    _ = monkey.*.takeFirstItem();
}
```