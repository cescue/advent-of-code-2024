# frozen_string_literal: true

class MemoryDecorruptor
  def initialize(memory:)
    @corrupted_memory = memory
    @instructions = extract_instructions
  end

  def extract_instructions
    @corrupted_memory.scan(/(mul)\((\d{1,3}),(\d{1,3})\)/)
                     .map do |match|
                       {
                         operation: match[0],
                         a: match[1].to_i,
                         b: match[2].to_i
                       }
                     end
  end

  def execute_instruction(number)
    case @instructions[number][:operation]
    when 'mul'
      @instructions[number][:a] * @instructions[number][:b]
    else
      raise ArgumentError, "Unsupported operation: #{@instructions[number][:operation]}"
    end
  end

  def total_instructions
    @instructions.length
  end
end

input_file = ARGV.first

corrupted_memory = File.read(input_file)

decorruptor = MemoryDecorruptor.new(memory: corrupted_memory)

total = 0

decorruptor.total_instructions.times do |i|
  total += decorruptor.execute_instruction(i)
end

puts total
