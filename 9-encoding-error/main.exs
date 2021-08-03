defmodule Main do
  def lines() do
    File.read!( "./input.txt" )
    #File.read!( "./input.test.txt" )
      |> String.trim() # Removes the last line
      |> String.split( "\n" ) # List of lines
      |> Enum.map( &String.to_integer/1 )
  end

  def makeup( vals, val ) do
    case vals do
      [ first | others ] -> 
        cond do
          first >= val -> makeup( others, val ) # Ignore values larger or equal to value
          val - first in others -> true
          true -> makeup( others, val ) # Recursive case
        end
      _ -> false
    end
  end

  def validation( values, step ) do
    case Enum.at( values, step ) do
      nil ->
        nil
      x -> 
        if makeup( Enum.take( values, step ), x ) do
          validation( tl( values ), step )
        else
          x
        end
    end
  end

  def validation_mk2( numbers, val, len \\ nil, iter \\ 0 ) do
    cond do
      len === nil -> validation_mk2( numbers, val, length( numbers ), length( numbers  ) * 2 )
      iter === (len * 50) -> # Recursive break case
        IO.inspect( iter )
        nil
      true ->
        chunk = Enum.take( numbers, div(iter, len) ) 

        if Enum.sum( chunk ) === val do
          chunk
        else
          validation_mk2( tl( numbers ) ++ [ hd( numbers ) ], val, len, iter + 1 )
        end
    end
  end

  def run(  ) do
    lines()
      |> (&{ &1, validation( &1, 25 ) }).()
      |> case do
        { _, nil } -> nil
        { lines, val } ->
          validation_mk2( lines, val )
            |> Enum.sort()
            |> (&( hd( &1 ) + (Enum.reverse( &1 ) |> hd()) ) ).()
      end
      |> IO.inspect()
  end
end

Main.run()

:c.q
