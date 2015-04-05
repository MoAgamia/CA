class reg do 

	def check (command) 
		if command == nil
			puts ("Error empty command")
		end

		commandArray = command.split(",")
		IFormatArray = ["lw", "addi", "lb", "lbu", "sw", "sb", "lui", "beq", "bne"]
		RFormatArray = ["add", "sub", "nor", "sll", "srl", "and", "jr", "slt", "sltu"]
		JFormatArray = ["j", "jal"]

		case commandArray[0]
			when IFormatArray.include?(commandArray[0])
				CheckIFormat(command)
			when RFormatArray.include?(commandArray[0])	
				CheckRFormat(command)
			when JFormatArray.include?(commandArray[0])
				CheckJFormat(command)
			else 
				puts ("Please write your command correctly")
		end
	end

	def CheckIFormat (command)
        if command.match(/^(\s*)(\w{2} | \w{3} | \w{4})(\s+)(\$\w)(\d |\d{2})(\s*),(\s*)((\$\w)(\d|\d{2})(\s*) | (\$\w+)(\s*)),(\s*)((\d+) | (\w+))(\s*)$/) || x.match(/^(\s*)(\w{2} | \w{3} | \w{4})(\s+)(\$\w)(\d |\d{2})(\s*),(\s*)(\d+)(\()(\s*)(\$\w)(\d|\d{2})(\s*)(\))(\s*)$/) 
			return true
		else 
			return false
	end

	def CheckRFormat (command)
    if command.match(/^\s*(\w{2} | \w{3} | \w{4})(\s+)(\$\w)(\d|\d{2})(\s*),(\s*)((\$\w)(\d|\d{2}) | (\$\w+))(\s*),(\s*)((\$\w)(\d|\d{2}) | (\$\w+))(\s*)$/)
			return true
		else 
			return false
	end

	def CheckJFormat (command)
		if command.match(/^(\s*)(\w | \w{3})(\s+)(\w+)(\s*)$/)
			return true
		else 
			return false
	end

end 
