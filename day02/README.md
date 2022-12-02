**Solution:**

The thing that takes time in this challenge is to model the relation between
the three shapes Rock, Paper and Scissor.

I use an object for that, with the keys being the pair of shapes like `AX`,
`BY`,... And use the values from the input to lookup for the pair result.

In TypeScript, we can't just use a string as an index of an object, because
they don't have the matching type. We can solve this by using
[`keyof typeof`](https://www.huy.rocks/everyday/04-11-2022-typescript-use-string-as-enum-key):

```typescript
const Scores = {
	'AX': DRAW, 'AY': WIN, 'AZ': LOSE,
	'BX': LOSE, 'BY': DRAW, 'BZ': WIN,
	'CX': WIN, 'CY': LOSE, 'CZ': DRAW,
};

type ScoreKey = keyof typeof Scores;
```

