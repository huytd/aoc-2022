package main

import (
	"fmt"
	"os"
	"strings"
)

func make2DArray(rows int, cols int) [][]int {
	result := make([][]int, rows)
	for i := 0; i < rows; i++ {
		result[i] = make([]int, cols)
	}
	return result
}

func readInput() [][]int {
	file, _ := os.ReadFile("input.txt")
	lines := strings.Split(string(file), "\n")
	rows := len(lines) - 1
	cols := len(lines[0])
	result := make2DArray(rows, cols)
	for i := 0; i < rows; i++ {
		for j, c := range lines[i] {
			result[i][j] = int(c - '0')
		}
	}
	return result
}

func isTreeVisible(row int, col int, trees [][]int) bool {
	rows := len(trees)
	cols := len(trees[0])
	left := true
	right := true
	up := true
	down := true
	// left
	for i := 0; i < col; i++ {
		if trees[row][i] >= trees[row][col] {
			left = false
			break
		}
	}
	// right
	for i := col + 1; i < cols; i++ {
		if trees[row][i] >= trees[row][col] {
			right = false
			break
		}
	}
	// up
	for i := 0; i < row; i++ {
		if trees[i][col] >= trees[row][col] {
			up = false
			break
		}
	}
	// down
	for i := row + 1; i < rows; i++ {
		if trees[i][col] >= trees[row][col] {
			down = false
			break
		}
	}
	return left || right || up || down
}

func scenicScore(row int, col int, trees [][]int) int {
	rows := len(trees)
	cols := len(trees[0])
	left := 1
	right := 1
	up := 1
	down := 1
	// left
	for i := col - 1; i > 0; i-- {
		if trees[row][i] < trees[row][col] {
			left += 1
		} else {
			break
		}
	}
	// right
	for i := col + 1; i < cols-1; i++ {
		if trees[row][i] < trees[row][col] {
			right += 1
		} else {
			break
		}
	}
	// up
	for i := row - 1; i > 0; i-- {
		if trees[i][col] < trees[row][col] {
			up += 1
		} else {
			break
		}
	}
	// down
	for i := row + 1; i < rows-1; i++ {
		if trees[i][col] < trees[row][col] {
			down += 1
		} else {
			break
		}
	}
	return left * right * up * down
}

func max(a, b int) int {
	if a > b {
		return a
	} else {
		return b
	}
}

func main() {
	trees := readInput()
	rows := len(trees)
	cols := len(trees[0])
	count := 0
	highest := 0
	for r := 0; r < rows; r++ {
		for c := 0; c < cols; c++ {
			// isVisible := 0
			if r == 0 || c == 0 || r == rows-1 || c == cols-1 || isTreeVisible(r, c, trees) {
				// isVisible = 1
				count++
				highest = max(highest, scenicScore(r, c, trees))
			}
			// fmt.Printf("%d ", isVisible)
		}
		// fmt.Println()
	}

	fmt.Printf("Part 1 = %d\n", count)
	fmt.Printf("Part 2 = %d", highest)
}
