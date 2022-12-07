import * as path from "https://deno.land/std@0.167.0/path/mod.ts"
import { readLines } from "https://deno.land/std@0.167.0/io/mod.ts"
import { printf } from "https://deno.land/std@0.167.0/fmt/printf.ts";

const overlappedCharacters = (strings: string[]): string[] => {
  	let overlapped = new Set(strings[0]);
  	for (let i = 1; i < strings.length; i++) {
    	const currentSet = new Set(strings[i]);
    	overlapped = new Set([...overlapped].filter(x => currentSet.has(x)));
  	}
  	return Array.from(overlapped);
};

const getPriority = (c: string): number => {
	const ch = c.charCodeAt(0);
	if (ch >= 97 && ch <= 122) {
		return ch - 'a'.charCodeAt(0) + 1;
	} else {
		return ch - 'A'.charCodeAt(0) + 27;
	}
};

const fileName = path.join(Deno.cwd(), "input.txt")
const reader = await Deno.open(fileName)

const Part1 = async () => {
	let sum = 0;
	for await (const line of readLines(reader)) {
		let mid = Math.ceil(line.length / 2);
		const [left, right] = [line.slice(0, mid), line.slice(mid)];
		const chars = overlappedCharacters([left, right]);
		sum += chars.map(c => getPriority(c)).reduce((total, n) => total + n, 0);
	}
	printf("Part 1 = %d\n", sum);
};

const Part2 = async () => {
	const inputs = [];
	let group: string[] = [];
	for await (const line of readLines(reader)) {
		if (group.length < 3) {
			group.push(line);
		} else {
			inputs.push(group);
			group = [line];
		}
	}
	if (group.length) inputs.push(group);

	let sum = 0;
	for (const group of inputs) {
		const chars = overlappedCharacters(group);
		sum += chars.map(c => getPriority(c)).reduce((total, n) => total + n, 0);
	}

	printf("Part 2 = %d\n", sum);
};

Part2();
