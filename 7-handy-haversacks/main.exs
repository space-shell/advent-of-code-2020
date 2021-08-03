defmodule Main do
  def lines() do
    File.read!( "./input.txt" )
      |> String.trim() # Removes the last line
      |> String.split( "\n" ) # List of lines
  end

  def number_of_bags( bags ) do
    bags
      |> Enum.map( &( &1 |> hd() |> String.split() ) ) # list of list of words
      |> Enum.map( &[ String.to_integer(hd( &1 )), Enum.join(tl( &1 ), " ") ] ) # Tuple of bag ammount and bag type
  end

  def bags( lines ) do
    lines
      |> Enum.map( &(Regex.scan( ~r/(^\w+\s\w+|\d\s\w+\s\w+)/, &1, capture: :all_but_first )) ) # list of bags and ammount strings
      |> Enum.map( &[ hd( &1 ) |> hd(), number_of_bags( tl(&1) ) ] ) # List of bag type and containing bags
  end

  def find_parent_bags( searches, bags, searched, found) do
    case bags do
      [ [ type , contents ] = bag | bs ] ->
        case searches do
          [ search | _ ] -> 
            matched = Enum.any?( contents, fn([ _ , t ]) -> t === search end )

            tracked = Enum.member?( found, type )


            cond do
              matched and not tracked ->
                find_parent_bags( searches ++ [ type ], bs, [ bag | searched ], [ type | found ] )
              true -> 
                find_parent_bags( searches, bs, [ bag | searched ], found )
            end
          _ -> found
        end
      _ ->
        case searches do
          [ _ | ss ] -> find_parent_bags( ss, searched, [], found ) 
          _ -> found
        end
    end
  end

  def find_containing_bags( search, bags, searched ) do
    case bags do
      [ bag | bs ] ->
        case bag do
          [ type, contents ] when type === search and length( contents ) === 0 -> 0
          [ type, contents ] when type === search -> 
            contents
              |> Enum.map( fn([ num, t ]) ->
                num + (num * find_containing_bags( t, searched ++ bs, [] )) end )
              |> Enum.sum()
              #|> (&(IO.inspect(&1) && &1)).()
          _ ->
            find_containing_bags( search, bs, [ bag | searched ] )
        end
      _ -> 0
    end
  end

  def run() do
    lines()
      |> bags
      #|> (&(IO.inspect(&1) && &1)).()
      #|> (&find_parent_bags( [ "shiny gold" ], &1, [], [] )).() # Part one
      #|> (&IO.inspect(Kernel.length( &1 ))).()
      |> (&find_containing_bags( "shiny gold", &1, [] )).() # Part two
      |> (&IO.inspect/1).()
  end
end

Main.run()

:c.q
