open Test


let intEqual = (~message=?, a: int, b: int) =>
  assertion(~message?, ~operator="intEqual", (a, b) => a === b, a, b)

let stringEqual = (~message=?, a: string, b: string) =>
  assertion(~message?, ~operator="stringEqual", (a, b) => a == b, a, b)

let booleanEqual = (~message=?, a: bool, b: bool) =>
  assertion(~message?, ~operator="booleanEqual", (a, b) => a == b, a, b)

