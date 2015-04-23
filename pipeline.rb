require './controlunit'

class Pipeline

	attr_accessor :pc, :registers, :data

	def initialize datapath # pc, instructions, labels
		@datapath = datapath
		@pc = datapath.pc
		@instructions = datapath.instructions
		@lables = datapath.labels
		@registers = datapath.registerValues
		@data = datapath.memory
		iterate
	end

	def iterate
		array = @instructions.dup
		arr = []
		puts "#{array}"
		for i in 0...(5 - array.length)
			array << nil
		end
		loop do
			arr.unshift array[0]# unless array.empty?
			arr.pop if arr.length > 5 || array.empty?
			puts "------------------------------------------------------------------------------"
			puts "#{arr}"
			for i in (arr.length - 1).downto(0)
				case i
				when 0
					fetch if arr[i] != nil
				when 1
					decode if arr[i] != nil
				when 2
					puts "	execute: #{arr[i]}" if arr[i] != nil
				when 3
					memory if arr[i] != nil
				when 4
					puts "	write: #{arr[i]}" if arr[i] != nil
				end
			end
			array.shift
			break if arr.all? {|x| x.nil?}
		end
	end

	def fetch
		@command = @instructions[@pc/4]
		puts "	fetch: #{@command} ---- pc: #{@pc/4}"
		@pc += 4
	end

	def decode
		format = Reg.get_format @command
		case format
		when 'i'
			puts "	i-decode: #{@command}"
		when 'r'
			puts "	decode: #{@command} ---- #{ControlUnit.rEncoder @command}"
		when 'j'
			puts "	j-decode: #{@command}"
		end
	end

	def execute
	end

	def memory
		split = Reg.decode @command
		return if not ["lw", "lb", "lbu", "sw", "sb", "lui"].include? split[0]
		rs = @registers[split.last.scan(/#{Reg.get_rs.join "|"}/)[0]]
		offset = split.last.scan(/\d+/)[0].to_i
		raise Exception.new "Cannot address a negative memory index" if rs < 0
		address = rs + offset
		case split[0]
		when "lw", "lui"
			raise Exception.new "Offset must be a multiple of four" if offset % 4 != 0
			(@data[address/4] == nil) ? 0 : @data[address/4]
		when "lb", "lbu"
			(@data[address] == nil) ? 0 : @data[address]
		when "sw"
			raise Exception.new "Offset must be a multiple of four" if offset % 4 != 0
			@data[address/4] = @registers[split[1]]
		when "sb"
			@data[address] = @registers[split[1]]
		end
	end

	def write
	end
end
