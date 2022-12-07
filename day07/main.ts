import * as path from "https://deno.land/std@0.167.0/path/mod.ts"

const fileName = path.join(Deno.cwd(), "input.txt")
const content = await Deno.readTextFile(fileName)

type FSNode = File | Dir;

type File = {
	name: string;
	size: number;
};

type Dir = {
	name: string;
	parent?: Dir;
	child: FSNode[];
	totalSize: number;
};

const createFile = (name: string, size: number): File => {
	return { name, size };
};

const createDir = (name: string, parent?: Dir): Dir => {
	return {
		name,
		child: [],
		parent,
		totalSize: 0
	};
};

const parseFileSystem = (input: string): FSNode => {
	const root: FSNode = createDir("/");
	const lines = input.split("\n");
	let i = 0;
	let head: Dir | null = null;
	while (i < lines.length - 1) {
		const currentLine = lines[i];
		if (currentLine.startsWith("$ cd")) {
			const folderName = currentLine.replace("$ cd ", "");
			if (folderName === "/") {
				head = root;
			} else if (folderName === "..") {
				if (head?.parent) {
					head = head.parent;
				}
			} else {
				const targetIndex: number = head!.child.findIndex((node: FSNode) => node.name === folderName);
				if (targetIndex !== -1) {
					head = head!.child[targetIndex] as Dir;
				}
			}
			i++;
		} else if (currentLine.startsWith("$ ls")) {
			i++;
			while (lines[i] && !lines[i].startsWith("$")) {
				if (lines[i].startsWith("dir")) {
					// Dir
					const dirName = lines[i].replace("dir ", "");
					head!.child.push(createDir(dirName, head!));
				} else {
					// File
					const [size, name] = lines[i].split(" ");
					head!.child.push(createFile(name, +size));
				}
				i++;
			}
		}
	}
	return root;
};

let sum = 0;
const calculateSize = (node: FSNode): number => {
	if ((node as Dir)?.child === undefined) {
		// it's a file
		return (node as File)!.size;
	} else {
		// it's a dir
		const currentNode = (node as Dir)!;
		const childs = currentNode.child;
		for (const child of childs) {
			currentNode.totalSize += calculateSize(child);
		}
		if (currentNode.name !== "/" && currentNode.totalSize <= 100000) {
			sum += currentNode.totalSize;
		}
		return currentNode.totalSize;
	}
};

const root = parseFileSystem(content);
const totalSize = calculateSize(root);

const seen = new WeakSet();
console.log(JSON.stringify(root, (key, value) => {
    if (typeof value === "object" && value !== null) {
      	if (seen.has(value)) {
        	return;
      	}
      	seen.add(value);
    }
    return value;
}, '  '));

console.log("Part 1 = ", sum);

const totalNeeded = 30000000 - (70000000 - totalSize);

console.log(totalNeeded);

const candidates: number[] = [];
const findFolder = (node: Dir) => {
	if (node) {
		if (node.name !== "/" && node.totalSize >= totalNeeded) {
			candidates.push(node.totalSize);
		}
		for (const child of node.child) {
			if ((child as Dir)?.child !== undefined) {
				const currentNode = (child as Dir)!;
				findFolder(currentNode);
			}
		}
	}
};

findFolder(root as Dir);
candidates.sort((a, b) => a - b);

console.log("Part 2 = ", candidates[0]);

