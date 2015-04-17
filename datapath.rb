class Datapath
	
	@@registerNumbers = {"$zero"=>0, "$0"=>0, "$at"=>1, "$v0"=>2, "$v1"=>3, "$t8"=>24, "$t9"=>25, "$k0"=>26, "$k1"=>27, "$gp"=>28, "$sp"=>29, "$fp"=>30, "$ra"=>31, "$t0"=>8, "$t1"=>9, "$t2"=>10, "$t3"=>11, "$t4"=>12, "$t5"=>13, "$t6"=>14, "$t7"=>15, "$a0"=>4, "$a1"=>5, "$a2"=>6, "$a3"=>7, "$s0"=>16, "$s1"=>17, "$s2"=>18, "$s3"=>19, "$s4"=>20, "$s5"=>21, "$s6"=>22, "$s7"=>23}
	
	@@registerValues = {"$zero"=>0, "$0"=>0, "$at"=>0, "$v0"=>0, "$v1"=>0, "$t8"=>0, "$t9"=>0, "$k0"=>0, "$k1"=>0, "$gp"=>0, "$sp"=>0, "$fp"=>0, "$ra"=>0, "$t0"=>0, "$t1"=>0, "$t2"=>0, "$t3"=>0, "$t4"=>0, "$t5"=>0, "$t6"=>0, "$t7"=>0, "$a0"=>0, "$a1"=>0, "$a2"=>0, "$a3"=>0, "$s0"=>0, "$s1"=>0, "$s2"=>0, "$s3"=>0, "$s4"=>0, "$s5"=>0, "$s6"=>0, "$s7"=>0, "IF"=>0, "ID"=>0,"EX"=>0, "MEM"=>0}

	@@stages = {"IF" => "", "ID"=>"", "EX"=>"", "MEM"=>"", "WB"=>""}



	def mux sel input0 input1
		if sel == "0"
			return input0
		else
			return input1
		end
	end
	
	def signExtend input
		x=""
		for i in 0..15 do
			x += "0"
		end
		
		return x+input
	end
	
	def adder input0 input1
		integer = input0.to_i(2) + input1.to_i(2)
		return (input).to_s(2)
	end
	
	def sll input amount
		return (input << amount).to_s(2)
	end
	

end
