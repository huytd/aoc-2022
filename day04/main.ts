import * as path from "https://deno.land/std@0.167.0/path/mod.ts"
import { readLines } from "https://deno.land/std@0.167.0/io/mod.ts"
import { printf } from "https://deno.land/std@0.167.0/fmt/printf.ts";

const fileName = path.join(Deno.cwd(), "input.txt")
const reader = await Deno.open(fileName)

const Part1 = async () => {
	let count = 0;
	for await (const line of readLines(reader)) {
		const [pair1, pair2] = line.split(",");
		const [s1, e1] = pair1.split("-").map(s => parseInt(s, 10));
		const [s2, e2] = pair2.split("-").map(s => parseInt(s, 10));
		if ((s1 <= s2 && e1 >= e2) || (s2 <= s1 && e2 >= e1)) {
			count++;
		}
	}
	printf("Part 1 = %d\n", count);
};

const Part2 = async () => {
	let count = 0;
	for await (const line of readLines(reader)) {
		const [pair1, pair2] = line.split(",");
		const [s1, e1] = pair1.split("-").map(s => parseInt(s, 10));
		const [s2, e2] = pair2.split("-").map(s => parseInt(s, 10));

		/*

		 	--s1---------e1----               s1 <= s2 && e1 >= s2
		 	--------s2-------e2

		 	--------------s1---------e1----   s1 >= s2 && s1 <= e2
		 	--------s2-------e2

		 	--s1-------------e1----           s1 <= s2 && e1 >= e2
		 	--------s2---e2

		 	---------s1--e1----              s1 >= s2 && e1 <= e2
		 	----s2-----------e2

		* */

		if ((s1 <= s2 && e1 >= s2) || (s1 >= s2 && s1 <= e2) ||
			(s1 <= s2 && e1 >= e2) || (s1 >= s2 && e1 <= e2)) {
			count++;
		}
	}

	printf("Part 2 = %d", count);
};

Part2()
