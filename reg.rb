class Reg

	@@IFormatArray = ["lw", "addi", "lb", "lbu", "sw", "sb", "lui", "beq", "bne"]
	@@conditions = ["addi", "bne", "beq"]
	@@RFormatArray = ["add", "sub", "nor", "and", "sll", "srl", "slt", "sltu", "jr"]
	@@shifts = ["sll", "srl"]
	@@JFormatArray = ["j", "jal"]
	
	def self.check command
		if command == nil
			puts ("Error empty command")
		end

		commandSplit = command.split


		if((@@IFormatArray.include? commandSplit[0].strip ) && (@@conditions.include? commandSplit[0]))
			self.checkIConditions command
		elsif(@@IFormatArray.include? commandSplit[0].strip)
			self.checkIFormat command			
		elsif ((@@RFormatArray.include? commandSplit[0].strip) && (@@shifts.include? commandSplit[0].strip)) 
			self.checkRShift command
		elsif ((@@RFormatArray.include? commandSplit[0].strip) && (commandSplit[0].strip == "jr"))
			self.checkRJump command
		elsif (@@RFormatArray.include? commandSplit[0].strip)
			self.checkRFormat command
		elsif (@@JFormatArray.include? commandSplit[0].strip)
			self.checkJFormat command
		else
			return "Command Not Found: #{commandSplit[0].strip}"
		end

	end

	def self.checkIFormat command
        if  command.match(/^(\s*)([a-z]{2,3})(\s+)(\$([a-z]{1,2}\d?)|zero)(\s*,\s*)(\d+)(\((\$([a-z]{1,2}\d?)|zero)\))(\s*)$/)
			return true
		else
			return false
		end
	end
	
	def self.checkIConditions command
		if command.match(/^(\s*)(\w{3,4})(\s+)(\$([a-z]{1,2}\d?)|zero)(\s*,\s*)(\$([a-z]{1,2}\d?)|zero)(\s*,\s*)(\d+)(\s*)$/)
			return true
		else
			return false
		end
	end
	
	def self.checkRFormat command
	    	if command.match(/^(\s*)([a-z]{2,4})(\s+)(\$(([a-z]{1,2}\d?)|zero))(\s*,\s*)(\$(([a-z]{1,2}\d?)|zero))(\s*,\s*)(\$(([a-z]{1,2}\d?)|zero))(\s*)$/)	
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
		if command.match(/^(jr)(\s+)(\$)(([a-z]{1,2}\d?)|zero)(\s*)$/)
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
	
	
	puts self.check("addi $t1, $t0 , 8 ")	
	
	puts self.check("lbu $t1, $t0 , 8 ")

end
