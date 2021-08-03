const data = (await Deno.readTextFile("./input.txt"))
  .split(/\n\n/) // Splits on empty lines
  .filter(Boolean);

/*
byr (Birth Year) - four digits; at least 1920 and at most 2002.
iyr (Issue Year) - four digits; at least 2010 and at most 2020.
eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
hgt (Height) - a number followed by either cm or in:
If cm, the number must be at least 150 and at most 193.
If in, the number must be at least 59 and at most 76.
hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
pid (Passport ID) - a nine-digit number, including leading zeroes.
cid (Country ID) - ignored, missing or not.
*/

const byr = str =>
  /^[0-9]{4}$/.test( str ) && parseInt( str, 10 ) >= 1920 && parseInt( str, 10 ) <= 2002

const iyr = str =>
  /^[0-9]{4}$/.test( str ) && parseInt( str, 10 ) >= 2010 && parseInt( str, 10 ) <= 2020

const eyr = str =>
  /^[0-9]{4}$/.test( str ) && parseInt( str, 10 ) >= 2020 && parseInt( str, 10 ) <= 2030

const hgt = str => {
  const reg = /^([0-9]{2,3})(cm|in)/

  if ( !reg.test( str ) ) return false

  const [ _, num, type ] =  str.match( reg )

  return ({
    'cm': n => n >= 150 && n <= 193,
    'in': n => n >= 59 && n <= 76,
  }[ type ])( parseInt( num ) )
}

const hcl = str =>
  /^#[0-9a-fA-F]{6}$/.test( str )

const ecl = str =>
  [ 'amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth' ].includes( str )

const pid = str =>
  /^[0-9]{9}$/.test( str )

const valid_fields = [
  ['byr', byr],
  ['iyr', iyr],
  ['eyr', eyr],
  ['hgt', hgt],
  ['hcl', hcl],
  ['ecl', ecl],
  ['pid', pid],
  // 'cid', // Not required
]

const valid = data
 .map((d) => d
      .split( /[\s]/g )
      .map(field => field.split(/[:]/g))
  )
  .filter( ({ length }) => length >= 7 )
  .filter( record =>
    valid_fields.every( ([ key, validate ]) =>
      record.reduce( ( acc, [ k, v ]) =>
        k === key ? validate( v ) : acc
      ,false )
    )
  )
  .reduce( ( acc ) => acc + 1, 0 )

console.log(valid);
