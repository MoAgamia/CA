class Datapath

	def mux sel input0 input1
		if sel == 0
			return input0
		else
			return input1
		end
	end

end
