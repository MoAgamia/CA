require './check_style'
require './pipeline'

class Datapath

	attr_accessor :pc, :instructions, :labels, :registerValues, :memory

	# @@registerValues = {"$zero"=>0, "$0"=>0, "$at"=>0, "$v0"=>0, "$v1"=>0, "$t8"=>0,
	# 	"$t9"=>0, "$k0"=>0, "$k1"=>0, "$gp"=>0, "$sp"=>0, "$fp"=>0, "$ra"=>0, "$t0"=>0,
	# 	"$t1"=>0, "$t2"=>0, "$t3"=>0, "$t4"=>0, "$t5"=>0, "$t6"=>0, "$t7"=>0, "$a0"=>0,
	# 	"$a1"=>0, "$a2"=>0, "$a3"=>0, "$s0"=>0, "$s1"=>0, "$s2"=>0, "$s3"=>0, "$s4"=>0,
	# 	"$s5"=>0, "$s6"=>0, "$s7"=>0, "IF"=>0, "ID"=>0,"EX"=>0, "MEM"=>0}

	# @@stages = {"IF" => "", "ID"=>"", "EX"=>"", "MEM"=>"", "WB"=>""}

	def initialize
		@stages = {"IF" => "", "ID"=>"", "EX"=>"", "MEM"=>"", "WB"=>""}
		@pc = 0
		@instructions = []
		@labels = {}
		@registerValues = {"$zero"=>0, "$0"=>0, "$at"=>0, "$v0"=>0, "$v1"=>0, "$t8"=>0,
			"$t9"=>0, "$k0"=>0, "$k1"=>0, "$gp"=>0, "$sp"=>50, "$fp"=>0, "$ra"=>0, "$t0"=>0,
			"$t1"=>0, "$t2"=>0, "$t3"=>0, "$t4"=>0, "$t5"=>0, "$t6"=>0, "$t7"=>0, "$a0"=>0,
			"$a1"=>0, "$a2"=>0, "$a3"=>0, "$s0"=>0, "$s1"=>0, "$s2"=>0, "$s3"=>0, "$s4"=>0,
			"$s5"=>0, "$s6"=>0, "$s7"=>0}
		@memory = []
	end

	def load_instructions instructions
		out = CheckStyle.check instructions
		puts "mips_> #{out[:errors]}" if out[:errors] != nil
		return if out[:errors] != nil
		@instructions = out[:instructions] if out[:instructions] != nil
		@labels = out[:labels] if out[:labels] != nil
		puts "mips_> #{@instructions}"
		puts "       #{@labels}"
		pipeline = Pipeline.new self
		# @pc = pipeline.pc
		# @memory = pipeline.data
	end

	def mux sel, input0, input1
		(sel == 0 || sel == '0') ? input0 : input1
	end

	def shift_left_two input
		input + "00"
	end

	def signExtend input
		(input[0] * 16) + input
	end

	def adder input0, input1
		(input0 + input1).to_s 2
	end

	def sll input, amount
		return (input << amount).to_s(2)
	end

	def binary_string number, bits
		"%0#{bits}b" % number
	end

	def get_bits str, s, e
		str.reverse[s..e].reverse
	end
end
