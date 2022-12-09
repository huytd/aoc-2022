package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

var MOVE_MAP = map[string]Point{
	"R": NewPointXY(1, 0),
	"L": NewPointXY(-1, 0),
	"U": NewPointXY(0, 1),
	"D": NewPointXY(0, -1),
}

func abs(x int) int {
	if x < 0 {
		return -x
	} else {
		return x
	}
}

func sign(x int) int {
	if x < 0 {
		return -1
	}
	if x > 0 {
		return 1
	}
	return 0
}

type Point struct {
	x int
	y int
}

func NewPoint() Point {
	return Point{0, 0}
}

func NewPointXY(x, y int) Point {
	return Point{x, y}
}

func SyncPosition(head *Point, tail *Point) {
	dx := head.x - tail.x
	dy := head.y - tail.y
	if abs(dx) > 1 || abs(dy) > 1 {
		tail.x += sign(dx)
		tail.y += sign(dy)
	}
}

func Solve(lines []string, ropeLen int) int {
	knots := make([]Point, ropeLen)
	tailTrace := make(map[Point]bool)
	tailTrace[knots[1]] = true
	for _, line := range lines {
		parsed := strings.Split(line, " ")
		direction := parsed[0]
		steps, _ := strconv.ParseInt(parsed[1], 10, 0)
		delta := MOVE_MAP[direction]
		count := 0
		for count < int(steps) {
			knots[0].x += delta.x
			knots[0].y += delta.y
			knotIdx := 1
			for knotIdx < ropeLen {
				SyncPosition(&knots[knotIdx-1], &knots[knotIdx])
				knotIdx++
			}
			tailTrace[knots[ropeLen-1]] = true
			count++
		}
	}
	return len(tailTrace)
}

func main() {
	content, _ := os.ReadFile("input.txt")
	lines := strings.Split(strings.Trim(string(content), "\n"), "\n")
	fmt.Printf("Part 1 = %d\n", Solve(lines, 2))
	fmt.Printf("Part 2 = %d\n", Solve(lines, 10))
}
