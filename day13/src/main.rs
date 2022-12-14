use std::{iter::Peekable, str::Chars};

// Grammar:
// list = "[" ~ (value ~ ("," ~ value))? ~ "]"
// value = (digit)+ | (list)+

#[derive(Debug, Clone)]
enum Data {
    Int(i32),
    List(Vec<Data>)
}

impl Data {
    pub fn is_int(&self) -> bool {
        !self.is_list()
    }

    pub fn is_list(&self) -> bool {
        match self {
            Self::Int(_) => false,
            _ => true
        }
    }

    pub fn to_list(&self) -> Self {
        Self::List(vec![self.clone()])
    }
}

fn parse_int(chars: &mut Peekable<Chars>) -> Result<i32, &'static str> {
    let mut content = String::new();
    while let Some(c) = chars.peek() {
        if c.is_digit(10) {
            content.push(chars.next().ok_or("Could not read next character!")?);
        } else {
            break;
        }
    }
    return Ok(content.as_str().parse().map_err(|_| "Could not parse number!")?);
}

fn parse_value(chars: &mut Peekable<Chars>) -> Result<Data, &'static str> {
    if let Some(c) = chars.peek() {
        if c.is_digit(10) {
            return Ok(Data::Int(parse_int(chars)?));
        } else {
            return Ok(parse_list(chars)?);
        }
    }
    Err("Could not parse next! Expected a number or a list")
}

fn parse_list(chars: &mut Peekable<Chars>) -> Result<Data, &'static str> {
    if let Some(c) = chars.peek() {
        if c.eq(&'[') {
            chars.next();
            let value = parse_value(chars)?;
            let mut result = vec![value];
            while let Some(ec) = chars.peek().cloned() {
                if ec.eq(&',') {
                    chars.next();
                    let next_value = parse_value(chars)?;
                    result.push(next_value);
                } else if ec.eq(&']') {
                    chars.next();
                    return Ok(Data::List(result));
                } else {
                    println!("Unknown token {}...", ec);
                    return Err("Unknown");
                }
            }
        }
    }
    return Ok(Data::List(vec![]));
}

#[derive(Debug)]
enum CompareResult {
    Return(bool),
    Skip
}

fn is_right_order(left: &Data, right: &Data) -> CompareResult {
    match (left, right) {
        // If both values are integers, the lower integer should come first.
        (Data::Int(left), Data::Int(right)) => {
            if left == right {
                return CompareResult::Skip;
            } else {
                return CompareResult::Return(left < right);
            }
        },

        // If both values are lists, compare the first value of each list, then the second value, and so on.
        (Data::List(left), Data::List(right)) => {
            let mut i = 0;
            while i < left.len() && i < right.len() {
                let a = &left[i];
                let b = &right[i];
                match is_right_order(&a, &b) {
                    CompareResult::Return(val) => return CompareResult::Return(val),
                    _ => i += 1
                }
            }
            if i >= left.len() {
                return CompareResult::Return(true);
            } else {
                return CompareResult::Return(false);
            }
        },
        // If exactly one value is an integer, convert the integer to a list which contains that integer as
        // its only value, then retry the comparison.
        _ => {
            let left = if left.is_int() { left.to_list() } else { left.clone() };
            let right = if right.is_int() { right.to_list() } else { right.clone() };
            return is_right_order(&left, &right);
        }
    }
}

fn main() -> Result<(), &'static str> {
    let contents = include_str!("../input.txt");
    let lines: Vec<&str> = contents.lines().collect();
    let pairs: Vec<&[&str]> = lines.split(|&line| line.len() == 0).collect();
    let mut sum = 0;
    for (index, pair) in pairs.iter().enumerate() {
        let l1 = parse_list(&mut pair[0].chars().peekable())?;
        let l2 = parse_list(&mut pair[1].chars().peekable())?;
        match is_right_order(&l1, &l2) {
            CompareResult::Return(true) => {
                sum += index + 1;
            },
            _ => {}
        }
    }
    println!("Part 1 = {}", sum);
    Ok(())
}
