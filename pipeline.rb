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
		# @id_control = {}
		# @ex_control = {}
		# @mem_control = {}
		iterate
	end

	# def iterate
	# 	array = @instructions.dup
	# 	arr = []
	# 	puts "#{array}"
	# 	for i in 0...(5 - array.length)
	# 		array << nil
	# 	end
	# 	loop do
	# 		arr.unshift array[0]# unless array.empty?
	# 		arr.pop if arr.length > 5 || array.empty?
	# 		puts "------------------------------------------------------------------------------"
	# 		puts "#{arr}"
	# 		for i in (arr.length - 1).downto(0)
	# 			case i
	# 			when 0
	# 				fetch if arr[i] != nil
	# 			when 1
	# 				decode if arr[i] != nil
	# 			when 2
	# 				puts "	execute: #{arr[i]}" if arr[i] != nil
	# 			when 3
	# 				memory if arr[i] != nil
	# 			when 4
	# 				puts "	write: #{arr[i]}" if arr[i] != nil
	# 			end
	# 		end
	# 		array.shift
	# 		break if arr.all? {|x| x.nil?}
	# 	end
	# end

	def iterate
		array = @instructions.dup
		arr = Array.new 5
		puts "instructions: #{@instructions}"
		j = 0
		loop do
			arr.unshift fetch
			arr.pop if arr.length > 5
			puts "------------------------------------------------------------------------------"
			puts "#{arr}"
			for i in (arr.length - 1).downto(0)
				case i
					when 0
						puts "	fetch: #{arr[i]} ---- #{(@pc-1)/4}" if arr[i] != nil
					when 1
						decode arr[i]
					when 2
						puts "	execute: #{arr[i]}"
					when 3
						memory arr[i] if arr[i]
					when 4
						puts "	write: #{arr[i]}"
				end
			end
			break if arr.all? {|x| x.nil?}
		end
	end

	def fetch
		return if @pc/4 >= @instructions.length
		command = @instructions[@pc/4]
		# @pc += 4
		@pc = @datapath.adder(@pc, 4).to_i 2
		command
	end

	def decode command
		return if command == nil
		format = Reg.get_format command
		case format
		when 'i'
			puts "	decode: #{command}"# ---- #{ControlUnit.iEncoder command, @pc}"
		when 'r'
			puts "	decode: #{command}"# ---- #{ControlUnit.rEncoder command}"
		when 'j'
			puts "	decode: #{command}"# ---- #{ControlUnit.jEncoder command}"
		end
	end

	def execute command
		return if command == nil
	end

	def memory command
		return if command == nil
		split = Reg.decode command
		if not ["lw", "lb", "lbu", "sw", "sb", "lui"].include? split[0]
			puts "	no memory: #{command}"
			return
		end
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
		puts "	memory: #{command}"
	end

	def write command
		pc = @datapath.adder(@pc, 4).to_i 2
		@pc = @datapath.
		return if command == nil
	end
end
