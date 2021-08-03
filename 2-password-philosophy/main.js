const count = ( str, c ) =>
  Array
    .from( str, s => s === c )
    .reduce( ( acc, s ) => s ? acc + 1 : acc, 0 )

const within = ( num, start, end ) =>
  num >= start && num <= end

 //

const lines = (await Deno.readTextFile("./input.txt"))
  .split("\n")
  .filter(Boolean)

const linesToTriple = lines
  .map( s => s.split( /[ :]/g ) )
  .map( t => t.filter( Boolean ) )
  .map( ([ range, ...rest ]) => [
      range
        .split( '-' )
        .map( Number )
    , ...rest
    ]
  )

const valid = linesToTriple
  .filter( ([ [ start, end ], char, pass ]) =>
    within( 
      count( pass, char )
      , start
      , end
      )
  )

const revalid = linesToTriple
  .filter( ([ [ start, end ], char, pass ]) =>
    Array
      .from( pass )
      .reduce( ( acc, c, i ) =>
        ( i + 1 === start || i + 1 === end ) && char === c
          ? !acc
          : acc
      , false
      )
    
  )

console.log( valid.length )

console.log( revalid.length )

