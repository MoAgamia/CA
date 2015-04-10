class Reg

	@@IFormatArray = ["lw", "addi", "lb", "lbu", "sw", "sb", "lui", "beq", "bne"]
	@@RFormatArray = ["add", "sub", "nor", "sll", "srl", "and", "jr", "slt", "sltu"]
	@@JFormatArray = ["j", "jal"]

	def self.check command
		if command == nil
			puts ("Error empty command")
		end

		commandSplit = command.split

		
		if(@@IFormatArray.include? commandSplit[0].strip)
			self.checkIFormat command
		elsif (@@RFormatArray.include? commandSplit[0].strip)
			self.checkRFormat command
		elsif (@@JFormatArray.include? commandSplit[0].strip)
			self.checkJFormat command
		end
		
	end

	def self.checkIFormat command
        if command.match(/^(\s*)(\w{2}|\w{3}|\w{4})(\s+)(\$\w)(\d |\d{2})(\s*),(\s*)((\$\w)(\d|\d{2})(\s*) | (\$\w+)(\s*)),(\s*)((\d+) | (\w+))(\s*)$/) || x.match(/^(\s*)(\w{2} | \w{3} | \w{4})(\s+)(\$\w)(\d |\d{2})(\s*),(\s*)(\d+)(\()(\s*)(\$\w)(\d|\d{2})(\s*)(\))(\s*)$/)
			return true
		else
			return false
		end
	end

	def self.checkRFormat command
    	if command.match(/^\s*(\w{2}|\w{3}|\w{4})(\s+)(\$\w)(\d|\d{2})(\s*),(\s*)((\$\w)(\d|\d{2}) | (\$\w+))(\s*),(\s*)((\$\w)(\d|\d{2}) | (\$\w+))(\s*)$/)
			return true
		else
			return false
		end
	end

	def self.checkJFormat command
		if command.match(/^(\s*)(j|jal)(\s+)(\w+)(\s*)$/)
			return true
		else
			return false
		end
	end

	 puts self.check("jr $t3")

end

