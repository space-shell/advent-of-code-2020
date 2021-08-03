defmodule Main do
  def lines() do
    File.read!( "./input.txt" )
    #File.read!( "./input.test.txt" )
      |> String.trim() # Removes the last line
      |> String.split( "\n" ) # List of lines
      |> Enum.map( &String.to_integer/1 )
  end

  def joltage_diff( joltages ) do
    case joltages do
      [ jolt, j | jolts ] -> 
        [ j - jolt | joltage_diff( [ j | jolts ] ) ]
      _ -> [  ]
    end
  end

  def tribonacci( n ) do
    cond do
      n === 1 -> 1
      n === 2 -> 2
      n === 3 -> 4
      n > 3 -> tribonacci(n-1) + tribonacci(n-2) + tribonacci(n-3)
    end
  end

  def run(  ) do
    [ 0 | lines() ]
      |> Enum.sort()
      |> joltage_diff()

      # Part 1
      #|> (&( &1 ++ [ 3 ] )).()
      #|> Enum.frequencies( )
      #|> (&( Map.fetch!( &1, 1 ) * Map.fetch!( &1, 3 ) )).()

      # Part 2
      |> Enum.chunk_by( &( &1 === 3 ) )
      |> Enum.reject( &Enum.any?( &1, fn n -> n === 3 end ) )
      |> Enum.group_by( &length/1 )
      |> Map.delete( 1 )
      |> Map.to_list()
      |> Enum.map( fn { delta, occour } -> :math.pow( tribonacci( delta ), length( occour ) ) end )
      |> Enum.reduce( fn x, acc -> x * acc end )

      |> IO.inspect()
  end
end

Main.run()

:c.q
