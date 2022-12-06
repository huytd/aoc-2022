import * as path from "https://deno.land/std@0.167.0/path/mod.ts"
import { printf } from "https://deno.land/std@0.167.0/fmt/printf.ts";

const fileName = path.join(Deno.cwd(), "input.txt")
const content = await Deno.readTextFile(fileName)

const lookup = (k: number): number => {
	let left = 0;
	let right = 0;
	while (right < content.length) {
		right++;
		const set = new Set(content.slice(left, right).split(''));
		if (set.size === k) {
			return right;
		}
		if (right - left >= k) {
			left++;
		}
	}
	return -1;
}

const Part1 = () => {
	const found = lookup(4);
	printf("Part 1 - Found at %d\n", found);
};

const Part2 = () => {
	const found = lookup(14);
	printf("Part 2 - Found at %d\n", found);
};

Part2();
