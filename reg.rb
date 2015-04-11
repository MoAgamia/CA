class Reg

	@@IFormatArray = ["lw", "addi", "lb", "lbu", "sw", "sb", "lui", "beq", "bne"]
	@@RFormatArray = ["add", "sub", "nor", "and", "sll", "srl", "slt", "sltu", "jr"]
	@@shifts = ["sll", "srl"]
	@@JFormatArray = ["j", "jal"]
	
	def self.check command
		if command == nil
			puts ("Error empty command")
		end

		commandSplit = command.split


		if(@@IFormatArray.include? commandSplit[0].strip)
			self.checkIFormat command
		elsif ((@@RFormatArray.include? commandSplit[0].strip) && (@@shifts.include? commandSplit[0].strip)) 
			self.checkRShift command
		elsif ((@@RFormatArray.include? commandSplit[0].strip) && (commandSplit[0].strip == "jr"))
			self.checkRJump command
		elsif (@@RFormatArray.include? commandSplit[0].strip)
			self.checkRFormat command
		elsif (@@JFormatArray.include? commandSplit[0].strip)
			self.checkJFormat command
		end

	end

	def self.checkIFormat command
        if command.match(/^(\s*)(\w{3,4})(\s+)(\$(\w{1,2}|\w{4}))(\d?)(\s*,\s+)(\$(\w{1,2}|\w{4}))(\d?)(\s*,\s+)(\d+)(\s*)$/) || command.match(/^(\s*)(\w{2,3})(\s+)(\$(\w{1,2}|\w{4}))(\d?)(\s*,\s+)(\d+)(\(\$(\w{1,2}|\w{4})(\d?)\))$/)
			return true
		else
			return false
		end
	end
	
	def self.checkRFormat command
    	if command.match(/^(\s*)(\w{2,4})(\s+)(\$(\w{1,2}|\w{4}))(\d{1,2})(\s*,\s+)(\$(\w{1,2}|\w{4}))(\d{1,2})(\s*,\s+)(\$(\w{1,2}|\w{4}))(\d{1,2})(\s*)$/)
			return true
		else
			return false
		end
	end
	
	def self.checkRShift command
		if command.match(/^(sll|srl)(\s+)(\$([a-z]{1,2}\d?)|zero)(\s*,\s*)(\$([a-z]{1,2}\d?)|zero)(\s*,\s*)(\d+)(\s*)$/)
			return true
		else
			return false
		end
	end
	
	def self.checkRJump command
		if command.match(/^(jr)(\s+)(\$)(([a-z]{1,2}\d)|zero)(\s*)$/)
			return true
		else
			return false
		end
	end
	

	def self.checkJFormat command
		if command.match(/^(\s*)(j|jal)(\s+)(\d+)(\s*)$/)
			return true
		else
			return false
		end
	end

	 puts self.check("sll $t0, $t0 ,4")


end