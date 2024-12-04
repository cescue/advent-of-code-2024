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

  def diagonal_down_matches_at(row, col, word)
    forward = 1
    reverse = 1

    word.length.times do |i|
      forward = 0 if out_of_bounds?(row + i, col + i) || word[i] != @lines[row + i][col + i]
      reverse = 0 if out_of_bounds?(row + i, col + i) || word.reverse[i] != @lines[row + i][col + i]
    end

    forward + reverse
  end

  def diagonal_up_matches_at(row, col, word)
    forward = 1
    reverse = 1

    word.length.times do |i|
      forward = 0 if out_of_bounds?(row - i, col + i) || word[i] != @lines[row - i][col + i]
      reverse = 0 if out_of_bounds?(row - i, col + i) || word.reverse[i] != @lines[row - i][col + i]
    end

    forward + reverse
  end

  def matches_at(row, col, word)
    midpoint = word.length / 2
    
    return 0 unless @lines[row][col] == word[midpoint]

    return 0 unless diagonal_up_matches_at(row + 1, col - 1, word) == 1
    return 0 unless diagonal_down_matches_at(row - 1, col - 1, word) == 1

    1
  end
end

input_file = ARGV.first

word_search = WordSearch.new(lines: File.readlines(input_file))

puts word_search.count_matches(word: 'MAS')
