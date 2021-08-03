const lines = (await Deno.readTextFile("./input.txt"))
  .split("\n")
  .filter(Boolean);

const splitUpper = (upper, [start, end]) =>
  Math.abs(end - start) <= 1
    ? upper
      ? end
      : start
    : upper
    ? [start + Math.ceil((end - start) / 2), end]
    : [start, end - Math.ceil((end - start) / 2)];

const ids = lines
  .map((line) =>
    Array.from(line).reduce(
      ([r, c], char, i) =>
        i <= 6
          ? [splitUpper(char === "B", r), c]
          : [r, splitUpper(char === "R", c)],
      [
        [0, 127],
        [0, 7],
      ]
    )
  )
  .map(([r, c]) => r * 8 + c);

const highest = ids.reduce((acc, val) => (val > acc ? val : acc), 0);

const missing = [...ids.sort()]
  .reduce(
    ([last, empty], id) =>
      last === null
        ? [id, empty]
        : id === last + 1
        ? [id, empty]
        : [id, [ ...empty, last + 1 ]],
    [null, []]
  );

console.log(highest);
console.log(missing);
