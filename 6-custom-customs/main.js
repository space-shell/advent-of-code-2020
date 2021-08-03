const groups = (await Deno.readTextFile("./input.txt"))
  .trim()
  .split("\n\n")
  .filter(Boolean)

const occourances = groups
  .map( group => group.split( /\s/ ) ) // return an array of lines
  .map( group => [ group.length, Array.from(group.join( '' )) ] ) // returns an tuple of line count and an array of chars
  .map( ([ lines, group ]) => [
    lines,
    group.reduce( ( acc, char ) => ({
      ...acc,
      [ char ]: acc[ char ] === undefined ? 1 : acc[ char ] + 1
    }), {  } )
  ] )

const sum_occourances = occourances
  .map( ([ _, group ]) => Object.keys( group ).length )
  .reduce( ( acc, val ) => acc + val, 0 )

const discriminate_occourances = occourances
  .map( ([ lines, group ]) => Object
    .values( group )
    .reduce( ( acc, val ) => acc + Number( val === lines ),0 )
  )
  .reduce( ( acc, val ) => acc + val, 0 )

console.log( sum_occourances )

console.log( discriminate_occourances )

