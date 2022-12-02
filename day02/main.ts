import * as path from "https://deno.land/std@0.167.0/path/mod.ts"
import { readLines } from "https://deno.land/std@0.167.0/io/mod.ts"
import { printf } from "https://deno.land/std@0.167.0/fmt/printf.ts";

const Choice = {
	'A': 1, 'X': 1, // rock
	'B': 2, 'Y': 2, // paper
	'C': 3, 'Z': 3, // scissor
};
type ChoiceKey = keyof typeof Choice;

const LOSE = 0;
const DRAW = 3;
const WIN = 6;

const Scores = {
	'AX': DRAW, 'AY': WIN, 'AZ': LOSE,
	'BX': LOSE, 'BY': DRAW, 'BZ': WIN,
	'CX': WIN, 'CY': LOSE, 'CZ': DRAW,
};
type ScoreKey = keyof typeof Scores;

const YourChoice = {
	'AX': 'Z', 'BX': 'X', 'CX': 'Y',
	'AY': 'X', 'BY': 'Y', 'CY': 'Z',
	'AZ': 'Y', 'BZ': 'Z', 'CZ': 'X',
};
type YourChoiceKey = keyof typeof YourChoice;

const getScore = (a: string, b: string): number => {
	const score = Scores[`${a}${b}` as ScoreKey];
	const point = Choice[b as ChoiceKey];
	return score + point;
};

const fileName = path.join(Deno.cwd(), "input.txt")
const reader = await Deno.open(fileName)

const Part1 = async () => {
	let totalScore = 0;

	for await (const line of readLines(reader)) {
		const [elf, me] = line.split(' ');
		totalScore += getScore(elf, me);
	}

	printf("Part 1 = %d\n", totalScore);
};

const Part2 = async () => {
	let totalScore = 0;

	for await (const line of readLines(reader)) {
		const [elf, expected] = line.split(' ');
		const me = YourChoice[`${elf}${expected}` as YourChoiceKey];
		totalScore += getScore(elf, me);
	}

	printf("Part 2 = %d\n", totalScore);
};

Part2();
