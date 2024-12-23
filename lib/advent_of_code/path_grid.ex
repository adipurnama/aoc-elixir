defmodule AdventOfCode.PathGrid.Unit do
  defstruct identifier: nil, position: nil
end

defmodule AdventOfCode.PathGrid do
  defstruct graph: nil, units: []

  alias AdventOfCode.PathGrid.Unit

  @doc """
  Parses the raw input as read from the input text file, eg.

  ```
  ###########
  #0.1.....2#
  #.#######.#
  #4.......3#
  ###########
  ```

  AOC consistently designs grids in the same way - impassable walls with `#`, and
  traversable spaces with `.`.

  Any other characters are designated as "units", and will have their identifiers/positions
  stored for later usage.
  """
  def new(input) do
    {graph, units, _row} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({Graph.new(vertex_identifier: & &1), [], 1}, &parse_row/2)

    %__MODULE__{graph: graph, units: units}
  end

  defp parse_row(row, {graph, units, row_num}) do
    {graph, units, _col_num} =
      row
      |> String.graphemes()
      # use 1, because 0 is the wall
      |> Enum.reduce({graph, units, 1}, fn char, {graph, units, col_num} ->
        units = parse_unit(char, units, {col_num, row_num})
        graph = parse_coord(char, graph, {col_num, row_num})
        {graph, units, col_num + 1}
      end)

    {graph, units, row_num + 1}
  end

  defp parse_unit(unit, units, _coord) when unit in ["#", ".", " "], do: units

  # parse to {x,y} coordinates
  defp parse_unit(unit, units, {x, y}) do
    [%Unit{identifier: unit, position: {x, y}} | units]
  end

  defp parse_coord(" ", graph, _), do: graph

  # parse to {x,y} coordinates
  defp parse_coord(char, graph, {x, y}) do
    coord_type = if char == "#", do: :wall, else: :floor
    graph = Graph.add_vertex(graph, {x, y}, coord_type)

    [{x, y - 1}, {x - 1, y}]
    |> Enum.reduce(graph, fn neighbour, graph ->
      if coord_type == :floor && floor?(graph, neighbour) do
        graph
        |> Graph.add_edge({x, y}, neighbour)
        |> Graph.add_edge(neighbour, {x, y})
      else
        graph
      end
    end)
  end

  def display(graph, units \\ [], highlight \\ []) do
    vertices = Graph.vertices(graph)
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(vertices, fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(vertices, fn {_, y} -> y end)

    for x <- min_x..max_x, y <- min_y..max_y do
      if unit = Enum.find(units, fn unit -> unit.position == {x, y} end) do
        unit.identifier
      else
        cond do
          floor?(graph, {x, y}) -> "."
          wall?(graph, {x, y}) -> "#"
          true -> " "
        end
      end
      |> maybe_highlight({x, y}, highlight)
    end
    |> Enum.chunk_every(max_x - min_x + 1)
    |> Enum.map(&List.to_string/1)
    |> Enum.map(&IO.puts/1)

    graph
  end

  def add_wall(graph, coord) do
    edges =
      graph
      |> Graph.in_neighbors(coord)
      |> Enum.flat_map(&[{&1, coord}, {coord, &1}])

    graph
    |> Graph.delete_edges(edges)
    |> Graph.remove_vertex_labels(coord)
    |> Graph.label_vertex(coord, :wall)
  end

  def remove_wall(graph, coord) do
    graph =
      graph
      |> Graph.remove_vertex_labels(coord)
      |> Graph.label_vertex(coord, :floor)

    coord
    |> neighbouring_coords()
    |> Enum.reduce(graph, fn neighbour, graph ->
      if floor?(graph, neighbour) do
        graph
        |> Graph.add_edge(coord, neighbour)
        |> Graph.add_edge(neighbour, coord)
      else
        graph
      end
    end)
  end

  def neighbouring_coords({row, col}) do
    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
    |> Enum.map(fn {o_row, o_col} ->
      {row + o_row, col + o_col}
    end)
  end

  def add_special_path(graph, {from, to}) do
    graph
    |> Graph.add_edge(from, to)
    |> Graph.add_edge(to, from)
  end

  def size(graph) do
    graph
    |> Graph.vertices()
    |> Enum.max()
  end

  def wall?(graph, coordinate) do
    Graph.has_vertex?(graph, coordinate) && Graph.vertex_labels(graph, coordinate) == [:wall]
  end

  def floor?(graph, coordinate) do
    Graph.has_vertex?(graph, coordinate) && Graph.vertex_labels(graph, coordinate) == [:floor]
  end

  def in_graph?(graph, coordinate) do
    Graph.has_vertex?(graph, coordinate)
  end

  def floor_spaces(graph) do
    Graph.vertices(graph)
    |> Enum.filter(fn v -> Graph.vertex_labels(graph, v) == [:floor] end)
  end

  def wall_spaces(graph) do
    Graph.vertices(graph)
    |> Enum.filter(fn v -> Graph.vertex_labels(graph, v) == [:wall] end)
  end

  defp maybe_highlight(char, coord, %MapSet{} = mapset) do
    if MapSet.member?(mapset, coord), do: colour(char), else: char
  end

  defp maybe_highlight(char, coord, list) when is_list(list) do
    if Enum.member?(list, coord), do: colour(char), else: char
  end

  defp colour(char) do
    # Red stands out most against white, at small and large text sizes
    IO.ANSI.red() <> "#{char}" <> IO.ANSI.reset()
  end
end
