require './controlunit'

class Pipeline

	attr_accessor :pc, :registers, :data

	def initialize datapath # pc, instructions, labels
		@datapath = datapath
		@pc = datapath.pc
		@instructions = datapath.instructions
		@labels = datapath.labels
		@registers = datapath.registerValues
		@data = datapath.memory
		# @id_control = {}
		# @ex_control = {}
		# @mem_control = {}
		iterate
	end

	def iterate
		arr = Array.new 5
		j = 0
		loop do
			arr.unshift fetch
			arr.pop if arr.length > 5
			break if arr.all? {|x| x.nil?}
			puts "------------------------------------------------------------------------------"
			puts "#{arr}"
			for i in (arr.length - 1).downto(0)
				case i
					when 0
						puts "	IF: #{arr[i]} ---- #{(@pc-1)/4}" if arr[i] != nil
						puts "	IF: NOP" if arr[i] == nil
					when 1
						decode arr[i]
					when 2
						execute arr[i]
					when 3
						memory arr[i]
					when 4
						write arr[i]
				end
			end
		end
	end

	def fetch
		return if @pc/4 >= @instructions.length
		command = @instructions[@pc/4]
		@pc = @datapath.adder(@pc, 4).to_i 2
		if command != nil && (Reg.jump_command? command)
			puts "	JUMP: #{command} ---- ADDRSS: #{@labels[command.split[1]].to_i / 4}"
			case command.split[0]
			when 'j', 'jal'
				label = @labels[command.split[1]]
				raise Exception.new "Jump instructions must have a valied address" if label == nil
				address = label.to_i / 4
			when 'jr'
				address = @registers[command.split[1]]/4
			end
			comm = "#{command.split[0]} #{address}"
			binary = ControlUnit.jEncoder comm
			jump_address = @datapath.get_bits(@datapath.binary_string(@pc, 32) ,28, 31) + @datapath.shift_left_two(@datapath.get_bits(binary, 0, 25))
			puts "	JMP: #{jump_address}"
			@registers["$ra"] = @pc - 4 if command.split[0] == 'jal'
			@pc = jump_address.to_i 2
		end
		command
	end

	def decode command
		puts "	ID: NOP" if command == nil
		return if command == nil
		format = Reg.get_format command
		case format
			when 'i'
				puts "	iID: #{command}"# ---- #{ControlUnit.iEncoder command, @pc}"
			when 'r'
				puts "	rID: #{command}"# ---- #{ControlUnit.rEncoder command}"
			when 'j'
				puts "	jID: #{command}"# ---- #{ControlUnit.jEncoder command}"
		end
	end

	def execute command
		puts "	EX: NOP" if command == nil
		return if command == nil
		@alu_result = 0
		puts "	EX: #{command}"
		if not Reg.jump_command? command

		end
	end

	def memory command
		puts "	MEM: NOP" if command == nil
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
			@read_data = (@data[address/4] == nil) ? 0 : @data[address/4]
		when "lb", "lbu"
			@read_data = (@data[address] == nil) ? 0 : @data[address]
		when "sw"
			raise Exception.new "Offset must be a multiple of four" if offset % 4 != 0
			@data[address/4] = @registers[split[1]]
		when "sb"
			@data[address] = @registers[split[1]]
		end
		puts "	MEM: #{command}"
	end

	def write command
		puts "	WB: NOP" if command == nil
		return if command == nil
		puts "	WB: #{command}"
		# return if command == nil
		# if @wb_control[:regwrite] == "0"
		# 	puts "	no write: #{command}"
		# 	return			
		# end
		# split = Reg.decode command
		# write_data = @datapath.mux @wb_control[:memtoreg], @read_data, @alu_result
		# @registers[split[1]] = write_data
	end
end
