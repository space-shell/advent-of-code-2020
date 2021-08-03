defmodule Main do
  def lines() do
    File.read!( "./input.txt" )
      |> String.trim() # Removes the last line
      |> String.split( "\n" ) # List of lines
  end
  
  def instructions( lines ) do
    lines
      |> Enum.map( &String.split/1 ) # Tuple of instructions and operators
      |> Enum.map( fn([ cmd, op ]) -> [ cmd | op |> String.split_at( 1 ) |> Tuple.to_list() ] end )
      |> Enum.map( fn([ cmd, op, amt ]) -> [ cmd, op, String.to_integer( amt ) ] end )
      |> Enum.map( &List.to_tuple/1 )
      |> Enum.with_index()
  end

  def commands( [ instruct | is ] = instructs, run \\ [] ) do
    { ins, index } = instruct 

    if index in run do
      [  ]
    else
      case ins do
        { "jmp", "+", ammount } ->
          { head, tail } = instructs |> Enum.split( ammount )

          commands( tail ++ head, [ index | run ] )
        { "jmp", "-", ammount } ->
          { head, tail } = instructs |> Enum.split( -ammount )

          commands( tail ++ head, [ index | run ] )
        { "nop", _, _ } ->
          commands( is ++ [ instruct ], [ index | run ] )
        _ ->
          [ ins | commands( is ++ [ instruct ], [ index | run ] ) ]
      end
    end
  end

  def accumulate( cmd ) do
    case cmd do
      [ { "acc", "+", ammount } | cs ] ->
        ammount + accumulate( cs )
      [ { "acc", "-", ammount } | cs ] ->
        -ammount + accumulate( cs )
      _ -> 0
    end
  end

  def run() do
    lines()
      |> instructions
      |> commands
      |> accumulate
      |> (&(IO.inspect(&1) && &1)).()
  end
end

Main.run()

:c.q
