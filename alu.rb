class ALU
	def initialize one, two, alu
		@one = one
		@two = two
		puts "ON: #{one}"
		puts "TW: #{two}"
		# alu_control = {"add" => "0010", "sub" => "0110", "and" => "0000", "or" => "0001", "slt" => "0111"}
		alu_control = {"add" => "0010", "sub" => "0110", "and" => "0000", "or" => "0001", "slt" => "0111", "sltu" => "1000", "sll" => "0011",
			"srl" => "0100", "nor" => "0101"}
		@alu = alu_control.key(alu).to_s
		execute
	end

	def execute
		case @alu
		when 'add'
			{:res => @one + @two, :zero => 0}
		when 'sub'
			{:res => @one - @two, :zero => (@one - @two == 0) ? 1 : 0}
		when 'and'
			{:res => @one & @two, :zero => (@one & @two == 0) ? 1 : 0}
		when 'or'
			{:res => @one | @two, :zero => (@one | @two == 0) ? 1 : 0}
		when 'slt'
			{:res => (@one < @two) ? 1 : 0, :zero => 0}
		when 'sltu'
			{:res => (@one < @two) ? 1 : 0, :zero => 0}
		when 'sll'

		when 'srl'

		when 'nor'
			{:res => flip_bits((@one | @two).to_s(2)).to_i(2), :zero => ((flip_bits (@one | @two).to_s 2).to_i(2) == 0) ? 1 : 0}
		end
	end

	def flip_bits binary
		flipped = (binary.length).times.map {|e|
			if binary[e] == '1'
				'0'
			else
				'1'
			end
		}.join
	end

	def get_int binary, signed=false
		return binary.to_i 2 if not signed
		negative = true if binary[0] == '1'
		return binary.to_i 2 if not negative
		flipped = (binary.length).times.map {|e|
				if binary[e] == '1'
					'0'
				else
					'1'
				end
			}.join
			flipped = -(1 + flipped.to_i(2))
	end
end
