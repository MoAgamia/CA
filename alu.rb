class ALU
	def initialize one, two, alu
		@one = one
		@two = two
		alu_control = {"add" => "0010", "sub" => "0110", "and" => "0000", "or" => "0001", "slt" => "0111"}
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
		end
	end
end