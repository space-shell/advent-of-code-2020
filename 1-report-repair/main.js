// import Data from './input.js'

/*
const main = (  ) => {
  const sortedData = Data.sort( (a, b) => a - b )

  const [ a, b ] = sortedData.reduce( ( acc, num, index ) => {
    const end = 

    if ( num + end > 2020 ) {
      return [
      ]
    } else {
      return [
      ]
    }
  })

  console.log( a, b )
}
*/

const lines = (await Deno.readTextFile("./input.txt"))
  .split("\n")
  .filter(Boolean)
  .map(Number)

const main = () => {
  return lines.reduce((acc, num) => {
    const diff = 2020 - num;

    const diffs = lines.reduce((acc2, num2) => {
      const diff2 = diff - num2;

      return lines.includes(diff2) ? diff2 * num2 * num : acc2;
    }, 0)

    return diffs || acc
  }, 0);
};

console.log(main())
