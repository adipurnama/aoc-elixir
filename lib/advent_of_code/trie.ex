defmodule Trie do
  defstruct children: %{}, is_end_of_word: false

  # Initialize a new Trie
  def new do
    %Trie{}
  end

  # Insert a word into the Trie
  def insert(trie, []), do: %{trie | is_end_of_word: true}

  def insert(%Trie{children: children} = trie, [head | tail]) do
    child = Map.get(children, head, %Trie{})
    new_child = insert(child, tail)
    new_children = Map.put(children, head, new_child)
    %{trie | children: new_children}
  end

  def insert(trie, word) do
    insert(trie, String.graphemes(word))
  end

  # Search for a word in the Trie
  def search(%Trie{is_end_of_word: end_of_word}, []), do: end_of_word

  def search(%Trie{children: children}, [head | tail]) do
    case Map.get(children, head) do
      nil -> false
      child -> search(child, tail)
    end
  end

  def search(trie, word) do
    search(trie, String.graphemes(word))
  end

  # Check if there is any word in the Trie that starts with the given prefix
  def starts_with(_trie, []), do: true

  def starts_with(%Trie{children: children}, [head | tail]) do
    case Map.get(children, head) do
      nil -> false
      child -> starts_with(child, tail)
    end
  end

  def starts_with(trie, prefix) do
    starts_with(trie, String.graphemes(prefix))
  end
end
