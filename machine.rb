require_relative './instruction_annotation'

class Memory
  attr_reader :value, :name

  def initialize(machine:, read:, write:, size:, name:)
    @machine = machine
    @name = name
    @read_cost = read
    @write_cost = write
    @max_size = size
    @value = 0;
    self
  end

  def add_heat(amount)
    @machine.add_heat(amount)
  end

  def get_value
    add_heat(@read_cost)
    @value
  end

  def set_value(value_setter)
    if value_setter.class == Integer
      new_value = value_setter
    elsif value_setter.class == Proc
      new_value = value_setter.call(@value)
    end
    add_heat(@write_cost)
    @value = new_value
  end
end

class Machine
  extend InstructionAnnotation

  attr_reader :heat_history

  def initialize()
    @mea = [
      Memory.new(machine: self, read: 10, write: 20, size: 16, name: 'mea0'),
      Memory.new(machine: self, read: 10, write: 20, size: 16, name: 'mea1')
    ]
    @meb = [
      Memory.new(machine: self, read: 10, write: 40, size: 16, name: 'meb0'),
      Memory.new(machine: self, read: 10, write: 40, size: 16, name: 'meb1')
    ]
    @ceca = Memory.new(machine: self, read: 0, write: 0, size: 16, name: 'ceca')
    @cecb = Memory.new(machine: self, read: 0, write: 1, size: 16, name: 'cecb')
    @bool = Memory.new(machine: self, read: 1, write: 0, size: 1, name: 'bool')

    @caches = [
      @mea,
      @meb,
      @ceca,
      @cecb,
      @bool,
    ].flatten
    # @disk = 100.times.map(Disk.new(read: 40, write: 32))
    # @cloud = 10.times.map(Disk.new(read: 40, write: 40, size: 64))
    @heat_history = []
  end

  def to_s
    mem_values = @caches.map { |c| "#{c.name}: #{c.value}"}.join(", ")
    "Machine(#{mem_values}, object_id: #{"0x00%x" % (object_id << 1)})"
  end

  def inspect
    to_s
  end

  def get_from_cache(addr)
    mem = get_cache(addr)
    mem.get_value
  end

  def set_to_cache(addr, value)
    mem = get_cache(addr)
    mem.set_value(value)
  end

  def add_heat(amount)
    current_heat = @heat_history[-1] || 0
    @heat_history.push(current_heat += amount)
  end

  def get_cache(address)
    addr_name = address[0..-3]
    mem = nil
    case addr_name
    when 'ce'
      mem = instance_variable_get("@#{address}")
    when 'me'
      mem = instance_variable_get("@#{address[0..-2]}")[address[-1].to_i]
    when 'bo'
      mem = @bool
    end
    mem
  end

  def compile(program)
    lines = program.split("\n").map(&:strip).reject(&:empty?)
    lines.each do |line|
      run_line(line)
    end
  end

  def run_line(line)
    instruction = line.split(" ")
    command = instruction[0]
    raise StandardError unless self.class.instructions.include?(command.to_sym)
    self.send(command, *instruction[1..-1])
  end

  # VM Instructions
  vm_instruction
  def plus(amount, location)
    set_to_cache(location, ->(current) { current += amount.to_i })
  end

  vm_instruction
  def minu(amount, location)
    set_to_cache(location, ->(current) { current -= amount.to_i })
  end

  vm_instruction
  def comb(location1, location2)
    value_from_1 = get_from_cache(location1)
    set_to_cache(location2, ->(current) { current += value_from_1 })
  end

  vm_instruction
  def copy(location1, location2)
    value_from_1 = get_from_cache(location1)
    set_to_cache(location2, value_from_1)
  end

  vm_instruction
  def swap(location1, location2)
    value_from_1 = get_from_cache(location1)
    value_from_2 = get_from_cache(location2)
    set_to_cache(location2, value_from_1)
    set_to_cache(location1, value_from_2)
  end
end