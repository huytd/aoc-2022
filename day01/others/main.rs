use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("../input.txt").unwrap();
    let mut content = String::new();
    file.read_to_string(&mut content).ok();
    let lines = content.lines().map(|line| line.parse::<i32>().unwrap_or(0)).collect::<Vec<i32>>();
    let mut calories = lines.split(|&x| x == 0).map(|g| g.iter().sum()).collect::<Vec<i32>>();
    calories.sort_by(|a, b| b.cmp(a));

    println!("Part 1 = {}", calories[0]);

    let sum_three: i32 = calories.iter().take(3).sum();
    println!("Part 2 = {}", sum_three);
}
