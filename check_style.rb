class CheckStyle
	require './reg'
	def self.check text
		text = text.split("\n")
		flag = true
		line = 0
		errors = []
		instructions = []
		labels = {}
		text.each { |c|
			line = line + 1
			next if (c =~ /^\#.*$/) != nil
			c = c.split("#")[0] if (c =~ /^.*\#+.*$/) != nil
			if (c =~ /^[a-zA-Z]\w*:\s+.*$/) != nil
				flag = Reg.check c.split(":")[1]
				instructions << c.split(":")[1].strip if flag
				labels["#{c.split(":")[0].strip}"] = (line - 1)  * 4
			else
				flag = Reg.check c
				instructions << c.strip if flag
			end
			if flag != true
				errors << {:command => c.strip, :line => line}
			end
		}
		flag = (errors.length == 0) ? true : false
		return {:instructions => instructions, :labels => labels} if flag
		{:errors => errors}
	end
end