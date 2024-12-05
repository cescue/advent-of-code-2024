# frozen_string_literal: true

class SafetyManualUpdate
  def self.parse_rules(ordering_rules)
    rules = {}

    ordering_rules.each_line.map { |line| line.chomp.split('|').map(&:to_i) }.each do |rule|
      rules[rule[0]] ||= []
      rules[rule[0]] << rule[1]
    end

    rules
  end

  def initialize(ordering_rules:, pages:)
    @ordering_rules = SafetyManualUpdate.parse_rules(ordering_rules)
    @pages = pages
  end

  def middle_page_number
    @pages[@pages.length / 2]
  end

  def correct_order?
    @ordering_rules.each do |preceding_page, following_pages|
      next unless @pages.rindex(preceding_page)

      following_pages.each do |following_page|
        next unless @pages.index(following_page)

        return false if @pages.rindex(preceding_page) > @pages.index(following_page)
      end
    end

    true
  end

  def correct_order!
    until correct_order?
      @ordering_rules.each do |preceding_page, following_pages|
        current_index = @pages.rindex(preceding_page)
        new_index = @pages.rindex(preceding_page)

        next unless new_index

        following_pages.each do |following_page|
          following_index = @pages.index(following_page)

          next unless following_index && @pages.rindex(preceding_page) > following_index

          new_index = following_index if new_index > following_index
        end

        next if new_index == current_index

        @pages[new_index], @pages[current_index] = @pages[current_index], @pages[new_index]
      end
    end
  end
end

input_file = ARGV.first

ordering_rules, page_updates = File.read(input_file).split("\n\n")

total = 0

page_updates.split("\n").map { |line| line.split(',').map(&:to_i) }.each do |pages|
  update = SafetyManualUpdate.new(ordering_rules: ordering_rules, pages: pages)

  next if update.correct_order?

  update.correct_order!

  total += update.middle_page_number
end

puts total

