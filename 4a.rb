# frozen_string_literal: true

class WordSearch
  def initialize(lines:)
    @lines = lines
  end

  def count_matches(word:)
    total = 0

    (0..@lines.length - 1).each do |row|
      (0..@lines[row].length).each do |col|
        total += matches_at(row, col, word)
      end
    end

    total
  end

  def out_of_bounds?(row, col)
    row >= @lines.length || col >= @lines[row].length || row < 0 || col < 0
  end

  def matches_at(row, col, word)
    horizontal_forward = 1
    horizontal_reverse = 1
    vertical_forward = 1
    vertical_reverse = 1
    diagonal_up_forward = 1
    diagonal_up_reverse = 1
    diagonal_down_forward = 1
    diagonal_down_reverse = 1

    word.length.times do |i|
      horizontal_forward = 0    if out_of_bounds?(row, col + i) || word[i] != @lines[row][col + i]
      horizontal_reverse = 0    if out_of_bounds?(row, col - i) || word[i] != @lines[row][col - i]
      vertical_forward = 0      if out_of_bounds?(row + i, col) || word[i] != @lines[row + i][col]
      vertical_reverse = 0      if out_of_bounds?(row - i, col) || word[i] != @lines[row - i][col]
      diagonal_up_forward = 0   if out_of_bounds?(row - i, col + i) || word[i] != @lines[row - i][col + i]
      diagonal_up_reverse = 0   if out_of_bounds?(row + i, col - i) || word[i] != @lines[row + i][col - i]
      diagonal_down_forward = 0 if out_of_bounds?(row + i, col + i) || word[i] != @lines[row + i][col + i]
      diagonal_down_reverse = 0 if out_of_bounds?(row - i, col - i) || word[i] != @lines[row - i][col - i]
    end

    horizontal_forward + horizontal_reverse +
    vertical_forward + vertical_reverse + diagonal_up_forward +
    diagonal_up_reverse + diagonal_down_forward + diagonal_down_reverse
  end
end

input_file = ARGV.first

word_search = WordSearch.new(lines: File.readlines(input_file))

puts word_search.count_matches(word: 'XMAS')