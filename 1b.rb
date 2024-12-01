# frozen_string_literal: true

input_file = ARGV.first

similarity_score = 0

left_list = []
occurrences_in_right_list = {}

File.foreach(input_file) do |line|
  left, right = line.split(' ')

  left_list << left.to_i

  occurrences_in_right_list[right.to_i] ||= 0
  occurrences_in_right_list[right.to_i] += 1
end

left_list.each do |number|
  next unless occurrences_in_right_list[number]

  similarity_score += number * occurrences_in_right_list[number]
end

puts similarity_score
