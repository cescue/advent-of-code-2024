# frozen_string_literal: true

class MemoryDecorruptor
  EXECUTE_OP = 'do()'
  DO_NOT_EXECUTE_OP = "don't()"

  def initialize(memory:)
    @corrupted_memory = memory
    @instructions = extract_instructions
  end

  def extract_instructions
    should_execute = true
    instructions = []
    current_instructions = ''

    @corrupted_memory.each_char do |c|
      current_instructions += c

      if should_execute && current_instructions.end_with?(DO_NOT_EXECUTE_OP)
        instructions << parse_instructions(current_instructions)

        current_instructions = ''
        should_execute = false
        next
      end

      if !should_execute && current_instructions.end_with?(EXECUTE_OP)
        current_instructions = ''
        should_execute = true
      end
    end

    instructions << parse_instructions(current_instructions) if should_execute && !current_instructions.empty?

    instructions.flatten
  end

  def parse_instructions(instructions)
    instructions.scan(/(mul)\((\d{1,3}),(\d{1,3})\)/)
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
