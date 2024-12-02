# frozen_string_literal: true

class ReactorReport
  def initialize(levels:)
    @levels = levels
  end

  def safe?
    previous_level_increased = nil

    (1..@levels.length - 1).each do |i|
      level_difference = @levels[i - 1] - @levels[i]

      increased = level_difference.negative?

      return false unless level_difference.abs.between?(1, 3)
      return false if !previous_level_increased.nil? && increased != previous_level_increased

      previous_level_increased = increased
    end

    true
  end
end

input_file = ARGV.first

total_safe_reports = 0

File.foreach(input_file) do |line|
  levels = line.split(' ').map(&:to_i)

  permutations = []

  (0..levels.length - 1).each do |i|
    report = ReactorReport.new(levels: levels.dup.tap { |x| x.delete_at(i) })

    if report.safe?
      total_safe_reports += 1
      break
    end 
  end
end

puts total_safe_reports