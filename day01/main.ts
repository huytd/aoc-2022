import * as path from "https://deno.land/std@0.167.0/path/mod.ts"
import { readLines } from "https://deno.land/std@0.167.0/io/mod.ts"
import { printf } from "https://deno.land/std@0.167.0/fmt/printf.ts";

const fileName = path.join(Deno.cwd(), "input.txt")
const reader = await Deno.open(fileName)

const calories = []
let sum = 0

for await (const line of readLines(reader)) {
	if (line != "") {
		sum += parseInt(line, 10)
	} else {
		calories.push(sum)
		sum = 0
	}
}

calories.sort((a, b) => b - a)

printf("Part 1 = %d\n", calories[0])

const sumThree = calories.slice(0, 3).reduce((sum, n) => sum + n, 0)
printf("Part 2 = %d", sumThree)
