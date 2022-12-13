package main

import (
	"fmt"
	"math"
	"os"
	"strings"
)

type Point struct {
	x int
	y int
}

func readInput(fileName string) ([][]int, Point, Point) {
	file, _ := os.ReadFile(fileName)
	lines := strings.Split(string(file), "\n")
	rows := len(lines)
	cols := len(lines[0])

	result := make([][]int, rows)
	for i := 0; i < rows; i++ {
		result[i] = make([]int, cols)
	}

	startPos := Point{0, 0}
	endPos := Point{0, 0}

	for i := 0; i < rows; i++ {
		for j, c := range lines[i] {
			if c == 'S' {
				startPos.x = j
				startPos.y = i
				result[i][j] = 0
			} else if c == 'E' {
				endPos.x = j
				endPos.y = i
				result[i][j] = int('z' - 'a')
			} else {
				result[i][j] = int(c - 'a')
			}
		}
	}

	return result, startPos, endPos
}

var Direction = []Point{
	{0, 1},
	{0, -1},
	{1, 0},
	{-1, 0},
}

func isWithinBoard(board [][]int, nx int, ny int) bool {
	w := len(board[0])
	h := len(board)
	return nx >= 0 && nx < w && ny >= 0 && ny < h
}

func isMovable(board [][]int, pos Point, newPos Point) bool {
	currentHeight := board[pos.y][pos.x]
	newHeight := board[newPos.y][newPos.x]
	return newHeight-currentHeight <= 1
}

func min(a, b int) int {
	if a < b {
		return a
	} else {
		return b
	}
}

func travel(board [][]int, start, end Point) int {
	visited := make(map[Point]bool)
	visited[start] = true
	queue := []Point{start}
	var pos Point
	cost := 0
	for len(queue) > 0 {
		k := len(queue)
		for i := 0; i < k; i++ {
			pos, queue = queue[0], queue[1:]
			if pos == end {
				return cost
			} else {
				for _, dir := range Direction {
					nx := pos.x + dir.x
					ny := pos.y + dir.y
					np := Point{nx, ny}
					if isWithinBoard(board, nx, ny) && isMovable(board, pos, np) && !visited[np] {
						visited[np] = true
						queue = append(queue, np)
					}
				}
			}
		}
		cost++
	}
	return math.MaxInt
}

func main() {
	board, start, end := readInput("input.txt")

	cost := travel(board, start, end)
	fmt.Printf("Part 1 = %d\n", cost)

	minCost := math.MaxInt
	for row := range board {
		for col := range board[row] {
			if board[row][col] == 0 {
				nstart := Point{col, row}
				cost := travel(board, nstart, end)
				// fmt.Printf("From %+v (%d) = %d\n", nstart, board[row][col], cost)
				minCost = min(minCost, cost)
			}
		}
	}
	fmt.Printf("Part 2 = %d\n", minCost)
}
