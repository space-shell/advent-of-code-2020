const lines = (await Deno.readTextFile("./input.txt"))
  .split("\n")
  .filter(Boolean)

const slopes = [
  [1, 1],
  [3, 1], // Values for part 1
  [5, 1],
  [7, 1],
  [1, 2]
]

const trees = slopes
  .map( ([ right, down ]) =>
    lines
      .filter( ( _, i ) => !( i % down ) )
      .map((line, i) => line[((i * right) % line.length)])
      .reduce((a, c) => a + Number(c === "#"), 0)
  )

// Part 1 - Addition total
console.log(trees.reduce( (a, c) => a + c, 0 ))

// Part 2 - Multiplicative total
console.log(trees.reduce( (a, c) => a * c, 1 ))
