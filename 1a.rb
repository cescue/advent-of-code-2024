# frozen_string_literal: true

input_file = ARGV.first

total_distance = 0

left_list = []
right_list = []

File.foreach(input_file) do |line|
  left, right = line.split(' ')

  left_list << left.to_i
  right_list << right.to_i
end

left_list.sort!
right_list.sort!

left_list.length.times { |i| total_distance += (left_list[i] - right_list[i]).abs }

puts total_distance
