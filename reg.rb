class Reg

  @i_format_array = ["lw", "lb", "lbu", "sw", "sb", "lui", "beq", "bne", "addi"]
  @r_format_array = ["add", "sub", "nor", "and", "slt", "sltu", "sll", "srl", "jr"]
  @j_format_array = ["j", "jal"]

  # ONLY THESE REGISTERS WILL BE ACCEPTED BY THE REGEX

  @zero = ["$zero", "$0"]
  @at = ["$at"]
  @params = ["$a0", "$a1", "$a2", "$a3"]
  @return = ["$v0", "$v1"]
  @temp = ["$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$t8", "$t9"]
  @save = ["$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7"]
  @kernel = ["$k0", "$k1"]
  @global = ["$gp"]
  @stack = ["$sp"]
  @frame = ["$fp"]
  @address = ["$ra"]

  @rd = @params + @return + @temp + @save + @stack
  @rd.map!{ |r| r = "\\" + r}
  @rs = @rd + @zero.map{ |r| r = "\\" + r}

  # def self.p s, n
  # 	string = "["
  # 	for i in 0...n
  # 		string += "\"$#{s}#{i}\""
  # 		string += ", " if i != n-1
  # 	end
  # 	string += "]"
  # 	puts string
  # end

  # self.p "k", 2

  def self.check command
    if command == nil
      puts ("Error empty command")
    end
    op = command.split[0]

    if @i_format_array.include? op
      self.check_i_format command
    elsif @r_format_array.include? op # DONE
      self.check_r_format command
    elsif @j_format_array.include? op # DONE
      self.check_j_format command
    else
      "Command Not Found: #{command.split[0]}"
    end
  end

  def self.check_i_format command
    # @rd = @params + @return + @temp + @save + @stack
    # @rd.map!{ |r| r = "\\" + r}
    # @rs = @rd + @zero.map{ |r| r = "\\" + r}
    op = command.split[0]
    case op
    when "addi"
      (command =~ /^(\s*)(#{op})(\s+)(#{@rd.join "|"})(,\s+)(#{@rs.join "|"})(,\s+)([-]?\d+)(\s*)$/) != nil
    when "beq", "bne"
      (command =~ /^(\s*)(#{op})(\s+)(#{@rs.join "|"})(,\s+)(#{@rs.join "|"})(,\s+)([a-zA-Z]\w*)(\s*)$/) != nil
    else
      if op[0] == 'l'
	(command =~ /^(\s*)(#{op})(\s+)(#{@rd.join "|"})(,\s+)([-]?\d+\((#{@rs.join "|"})\))(\s*)$/) != nil
      else
	(command =~ /^(\s*)(#{op})(\s+)(#{@rs.join "|"})(,\s+)([-]?\d+\((#{@rs.join "|"})\))(\s*)$/) != nil
      end
    end
  end

  def self.check_r_format command
    # @rd = @params + @return + @temp + @save + @stack
    # @rd.map!{ |r| r = "\\" + r}
    # @rs = @rd + @zero.map{ |r| r = "\\" + r}
    op = command.split[0]
    case op
    when "sll", "srl"
      (command =~ /^(#{op})(\s+)(#{@rd.join "|"})(,\s+)(#{@rs.join "|"})(,\s+)(\d+)(\s*)$/) != nil
    when "jr"
      (command =~ /^(\s*)(#{op})(\s+)(\$ra)(\s*)$/) != nil
    else
      (command =~ /^(\s*)(#{op})(\s+)(#{@rd.join "|"})(,\s+)(#{@rs.join "|"})(,\s+)(#{@rs.join "|"})(\s*)$/) != nil
    end
  end

  def self.check_j_format command
    (command =~ /^(\s*)(#{command.split[0]})(\s+)([a-zA-Z]\w*)(\s*)$/) != nil
  end

  # TESTING COMMANDS
  # WHEN SELF.RUN, TYPE ANY COMMAND
  # IF IT'S VALID, THE CONSOLE PRINTS TRUE AND SPLITS THE COMMAND INTO ARRAY ELEMENTS
  # OTHERWISE IT PRINTS FALSE

  # EXAMPLE
  # add $t5, $zero, $zero
  # true: ["add", "$t5", "$zero", "$zero"]

  def self.decode command
    command.split.map{ |s| s.gsub(",", "")}
  end

  def self.run
    print "command_> "
    x = gets.chomp
    while x != "q"
      res = self.check(x)
      out = "#{res}"
      out += ": #{self.decode x}" if res == true
      puts out
      print "command_> "
      x = gets.chomp
    end
  end

  self.run

  puts self.check("addi $t1, $t0, -8")

  puts self.check("lbu $t1, $t0, 8")

  puts self.check("lbu $0, 0($t0)")

  puts self.check("lbu $t0, 0($t0)")

  puts self.check("jal LOOP")

  puts self.check("jal 3LOOP")

  puts self.check("jr $ra")

  puts self.check("beq $0, $0, LOOP3")

  puts self.check("beq $0, $0, 9")

end
