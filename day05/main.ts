import * as path from "https://deno.land/std@0.167.0/path/mod.ts"
import { readLines } from "https://deno.land/std@0.167.0/io/mod.ts"
import { printf } from "https://deno.land/std@0.167.0/fmt/printf.ts";

const fileName = path.join(Deno.cwd(), "input.txt")
const content = await Deno.readTextFile(fileName)
const lines = content.split("\n");
const separatorIdx = lines.findIndex(line => line.length === 0);
const [blocks, actionLog] = [lines.slice(0, separatorIdx-1), lines.slice(separatorIdx+1)];

const parseRow = (input: string): string[] => {
	const cols = [];
	for (let i = 0; i < input.length; i += 3) {
		cols.push(input.slice(i, i + 3).trim());
		i++;
	}
	return cols;
};

const parseBlocks = (blocks: string[]): string[][] => {
	const rows = blocks.map(line => parseRow(line));
	const stacks: string[][] = [];
	for (const row of rows) {
		for (let col = 0; col < row.length; col++) {
			if (!stacks[col]) {
				stacks[col] = [];
			}
			if (row[col] && row[col].length) {
				stacks[col].push(row[col]);
			}
		}
	}
	return stacks;
};

type Move = {
	count: number;
	from: number;
	to: number;
};

const parseMoves = (actionLog: string[]): Move[] => {
	return actionLog.reduce((moves: Move[], log) => {
		const parsed = log.match(/move (\d+) from (\d+) to (\d+)/);
		if (parsed !== null) {
			const [_, count, from, to] = parsed;
			moves.push({
				count: +count,
				from: +from - 1,
				to: +to - 1
			});
		}
		return moves;
	}, []);
};

const stacks = parseBlocks(blocks);
const moves = parseMoves(actionLog);

const Part1 = () => {
	for (const {count, from, to} of moves) {
		const take: string[] = stacks[from].splice(0, count).reverse();
		stacks[to] = take.concat(stacks[to]);
	}
	const msg = stacks.reduce((msg, stack) => msg += stack[0].replace(/(\[|\])/g, ''), "");
	printf("Part 1 = %s\n", msg);
};

const Part2 = () => {
	for (const {count, from, to} of moves) {
		const take: string[] = stacks[from].splice(0, count);
		stacks[to] = take.concat(stacks[to]);
	}
	const msg = stacks.reduce((msg, stack) => msg += stack[0].replace(/(\[|\])/g, ''), "");
	printf("Part 2 = %s\n", msg);
};

Part2();
