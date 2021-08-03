defmodule Main do
  def lines() do
    #File.read!( "./input.txt" )
    File.read!( "./input.txt" )
      |> String.trim() # Removes the last line
      |> String.split( "\n" ) # List of lines
      |> Enum.map( &String.graphemes/1 )
  end

  def neibours( iter, cols, value, offset ) do
    iter
      |> div( cols )
      |> (&( &1 * cols + ( cols * offset ) )).()
      |> (&( &1..( &1 + cols - 1 ) )).()
      #|> Enum.filter( &( &1 in (
      #    [ - 1, 0, 1 ]
      #      |> Enum.flat_map( fn n -> [ n - 10, n, n + 10 ] end )
      #      |> Enum.map( fn n -> n + iter end )
      #))) # Remove values within the same row but not neibours
      |> Enum.reject( &( &1 < 0 ) ) # Remove values below 0, Enum.at accepts negative values
      |> (&( if value in &1, do: value, else: nil )).()
  end

  def occupied( array, cols, iter, count ) do
    [ { iter - cols - 1, -1 },
      { iter - cols, -1 },
      { iter - cols + 1, -1 },
      { iter - 1, 0 },
      { iter + 1, 0 },
      { iter + cols - 1, 1 },
      { iter + cols, 1 },
      { iter + cols + 1, 1 }
    ]
      |> Enum.map( fn { value, offset } -> neibours( iter, cols, value, offset ) end )
      |> Enum.reject( &( &1 === nil ) )
      |> Enum.map( &Enum.at( array, &1 ) )
      |> Enum.filter( &( &1 === "#" ) )
      |> (&( length( &1 ) >= count )).()
  end

  def iteration( array, cols, iter \\ 0 ) do
    if iter === length( array ) do
      [  ]
    else
      Enum.at( array, iter )
        |> case do
            "L" ->
              if occupied( array, cols, iter, 1 ), do: "L", else: "#"
            "#" ->
              if occupied( array, cols, iter, 4 ), do: "L", else: "#"
            "." -> "."
        end
        |> (&[ &1 | iteration( array, cols, iter + 1 ) ]).()
    end
  end

  def iterate( array, cols ) do
    case iteration( array, cols ) do
      m when m === array -> m
      m -> iterate( m, cols )
    end
  end

  def run() do
    lines()
      |> (&(iterate( List.flatten( &1 ), hd( &1 ) |> length() ))).()
      |> Enum.reduce( 0, fn c, acc -> if c === "#", do: acc + 1, else: acc end )
      |> IO.inspect()
  end
end

Main.run()

:c.q
