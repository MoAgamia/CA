class CheckStyle
	require './reg'
	def self.check text
		text = text.split("\n")
		flag = true
		line = 0
		loffset = 0
		boffset = 0

		errors = []
		instructions = []
		labels = {}

		text.each { |c|
			line = line + 1
			loffset += 1 and next if c.strip.empty?
			loffset += 1 and next if (c =~ /^\#.*$/) != nil

			c = c.split("#")[0] if (c =~ /^.*\#+.*$/) != nil
			if (c =~ /^[a-zA-Z]\w*:\s+.*$/) != nil
				flag = Reg.check c.split(":")[1]
				if flag
					instructions << c.split(":")[1].strip
					if Reg.branch_command? c.split(":")[1]
						instructions << nil << nil
						boffset += 2
					end
					labels["#{c.split(":")[0].strip}"] = (line + boffset - loffset - 1) * 4
				end
			else
				flag = Reg.check c
				instructions << c.strip if flag
				boffset += 2 and instructions << nil << nil if Reg.branch_command? c
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