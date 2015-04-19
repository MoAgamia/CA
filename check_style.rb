class CheckStyle
	require './reg'
	def self.check text
		text = text.split("\n")
		flag = true
		line = 0
		errors = []
		instructions = []
		text.each { |c|
			line = line + 1
			next if (c =~ /^\#.*$/) != nil
			if (c =~ /^[a-zA-Z]\w*:\s+.*$/) != nil
				flag = Reg.check c.split(":")[1]
				instructions << c.split(":")[1].strip if flag
			else
				flag = Reg.check c
				instructions << c.strip if flag
			end
			if flag != true
				errors << {:command => c.strip, :line => line}
			end
		}
		flag = (errors.length == 0) ? true : false
		return instructions if flag
		{:errors => errors}
	end
end