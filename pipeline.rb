require './controlunit'
require './alu'
require './info'

class Pipeline

	attr_accessor :pc, :registers, :data

	def initialize datapath
		@datapath = datapath
		@pc = datapath.pc
		@instructions = datapath.instructions
		@labels = datapath.labels
		@registers = datapath.registerValues
		@data = datapath.memory
		@info = Information.new
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
		puts "------------------------------------------------------------------------------"
		puts " VAL: #{@registers}"
	end

	def fetch
		@info.push Hash.new if @pc/4 >= @instructions.length
		return if @pc/4 >= @instructions.length
		command = @instructions[@pc/4]
		@info.push({:pc => @pc})
		@pc = @datapath.adder(@pc, 4).to_i 2

		# HANDLING JUMP INSTRUCTIONS
		if command != nil && (Reg.jump_command? command)
			puts "	JUMP: #{command} ---- ADDRSS: #{@labels[command.split[1]].to_i / 4}"
			case command.split[0]
			when 'j', 'jal'
				label = @labels[command.split[1]]
				raise Exception.new "Jump instructions must have a valid address" if label == nil
				address = label.to_i / 4
			when 'jr'
				address = @registers[command.split[1]]/4
			end
			comm = "#{command.split[0]} #{address}"
			encoding = ControlUnit.jEncoder comm
			jump_address = @datapath.get_bits(@datapath.binary_string(@pc, 32) ,28, 31) + @datapath.shift_left_two(@datapath.get_bits(encoding, 0, 25))
			puts "	JMP: #{jump_address}"
			@registers["$ra"] = @pc - 4 if command.split[0] == 'jal'
			@pc = jump_address.to_i 2
		elsif command != nil && (Reg.branch_command? command)
			label = @labels[command.split[3]]
			address = (label.to_i - @pc)/4
			parsed = command.dup.split
			parsed[3] = address.to_s
			parsed = parsed.join(" ")
			encoding = ControlUnit.iEncoder parsed, @pc
			puts "	LOC: #{parsed}"
			puts "	EN: #{encoding}"
		elsif command != nil
			encoding = ControlUnit.encode command
		end
		@info.append ({:encoding => encoding}), 0
		command
	end

	def decode command
		puts "	ID: NOP" if command == nil
		return if command == nil
		hash = @info.array[1]
		encoding = hash[:encoding]
		signals = ControlUnit.get_signals(command.split[0])
		@info.append ({:signals => signals, :sign_extended => @datapath.signExtend(@datapath.get_bits(encoding, 0, 15))}), 1
		two = ControlUnit.get_register(@datapath.get_bits encoding, 16, 20)
		dest = ControlUnit.get_register(@datapath.get_bits encoding, 11, 15)
		@info.append ({:one => ControlUnit.get_register(@datapath.get_bits encoding, 21, 25), :two => two}), 1
		@info.append ({:dest => @datapath.mux(signals[:regdst], two, dest)}), 1
		puts "	ID: #{command} ---- EN: #{encoding} ---- SIG: #{signals}"
		@info.remove :encoding, 1
	end

	def execute command
		puts "	EX: NOP" if command == nil
		return if command == nil
		return if Reg.jump_command? command
		hash = @info.array[2]
		pc = hash[:pc]
		signals = hash[:signals]
		sign_extended = hash[:sign_extended]
		add_result = @datapath.adder(pc, @datapath.shift_left_two(sign_extended).to_i(2))
		# puts "	ADD: #{add_result.to_i 2} ---- PC: #{pc} ---- 16: #{@datapath.shift_left_two(@datapath.signExtend(@datapath.get_bits(encoding, 0, 15))).to_i(2)}"
		one = hash[:one]
		two = hash[:two]
		aluop = signals[:aluop]
		alu = ALU.new @registers[one], @datapath.mux(signals[:alusrc], @registers[two], sign_extended.to_i(2)), aluop
		alu = alu.execute
		alu_result = alu[:res]
		zero = alu[:zero]
		@pc = @datapath.mux (zero & signals[:branch].to_i), @pc, add_result.to_i

		@info.remove :sign_extended, 2
		@info.remove :one, 2
		@info.remove :two, 2
		@info.append ({:alu => alu_result}), 2

		puts "	EX: #{command} ---- ONE: #{one} ---- TWO: #{two} ---- ALU: #{aluop} ---- SIG: #{signals}"
	end

	def memory command
		# puts "	#{@info.array}"
		puts "	MEM: NOP" if command == nil
		return if command == nil
		hash = @info.array[3]
		signals = hash[:signals]
		split = Reg.decode command
		if not ["lw", "lb", "lbu", "sw", "sb", "lui"].include? split[0]
			puts "	no memory: #{command} ---- SIG: #{signals}"
			return
		end
		rs = @registers[split.last.scan(/#{Reg.get_rs.join "|"}/)[0]]
		offset = split.last.scan(/\d+/)[0].to_i
		raise Exception.new "Cannot address a negative memory index" if rs < 0
		address = rs + offset
		case split[0]
		when "lw", "lui"
			raise Exception.new "Offset must be a multiple of four" if offset % 4 != 0
			read_data = (@data[address/4] == nil) ? 0 : @data[address/4]
		when "lb", "lbu"
			read_data = (@data[address] == nil) ? 0 : @data[address]
		when "sw"
			raise Exception.new "Offset must be a multiple of four" if offset % 4 != 0
			@data[address/4] = @registers[split[1]]
		when "sb"
			@data[address] = @registers[split[1]]
		end
		@info.append ({:memory=>read_data}), 3
		puts "	MEM: #{command} ---- SIG: #{signals}"
	end

	def write command
		puts "	WB: NOP" if command == nil
		return if command == nil
		hash = @info.array[4]
		signals = hash[:signals]
		alu = hash[:alu]
		read = hash[:memory]
		dest = hash[:dest]
		@registers[dest] = @datapath.mux signals[:memtoreg], read, alu if signals[:regwrite] == "1"
		puts "	WB: #{command} ---- DEST: #{dest} ---- SIG: #{signals}"
	end
end
