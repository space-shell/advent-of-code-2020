/*
const lines = (await Deno.readTextFile("./input.test.txt"))
  .split("\n")
  .filter(Boolean);
*/

const number_of_bags = (bags) => {
  const [num, ...type] = bags.split(" ");

  return [num, type.join(" ")];
};

const bags = lines => lines
  .map((line) => line.match(/(^|[0-9]\s)(.\w+)(\s\w+)/g))
  .map(([bag, ...contains]) => [bag, contains.map(number_of_bags)]);

const find_parent_bags = (
  [search, ...searches],
  [bag, ...bags],
  searched,
  found = []
) => {
  if (!bag)
    return !search ? found : find_parent_bags(searches, searched, [], found);

  const [type, contents] = bag;

  const in_found = found.includes(type) ? [] : [type];

  const args = contents.some(([_, t]) => t === search)
    ? [
        [search, ...searches, ...in_found],
        bags,
        [bag, ...searched],
        [...in_found, ...found],
      ]
    : [[search, ...searches], bags, [bag, ...searched], found];

  return find_parent_bags(...args);
};

console.log(find_parent_bags(["shiny gold"], bags( lines ), []));

/*
function* find_parent_bags(
  [search, ...searches],
  [bag, ...bags],
  searched,
  found = []
) {
  if (!bag && search)
    return yield* find_parent_bags(searches, searched, [], found)

  const [type, contents] = bag;

  const in_found = found.includes(type) ? [] : [type];

  const contains_bag = contents.some(([_, t]) => t === search)
  
  if ( contains_bag )
    yield type

  const args = contains_bag
    ? [
        [search, ...searches, ...in_found],
        bags,
        [bag, ...searched],
        [...in_found, ...found],
      ]
    : [[search, ...searches], bags, [bag, ...searched], found];

  yield* find_parent_bags(...args);
}

for ( const i of find_parent_bags(["shiny gold"], bags, []) )
  console.log( i )
*/
