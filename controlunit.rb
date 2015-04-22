class ControlUnit

  @@controlSignals = {:regdst => "0", :branch => "0", :memwrite => "0", :memread => "0", :regwrite => "0", :memtoreg => "0", :jump => "0",  :alusrc => "0", :aluop => "0"}

  @@opCodes = {:lw =>"100011", :lb =>"100000", :lbu =>"100100", :sw =>"101011", :sb =>"101000", :lui =>"001111", :beq =>"000100", :bne =>"000101", :addi =>"001000", :add =>"000000", :sub =>"000000", :nor =>"000000", :and =>"000000", :slt =>"000000", :sltu =>"000000", :sll =>"000000", :srl =>"000000", :jr =>"000000", :j =>"000010", :jal=>"000011"}

  @@functionCodes = {"add"=>"100000", "sub"=>"100010", "nor"=>"100111", "and"=>"100100", "slt"=>"101010", "sltu"=>"101011", "sll"=>"000000", "srl"=>"000010", "jr"=>"001000"}

  @@registerNumbers = {"$zero"=>0, "$0"=>0, "$at"=>1, "$v0"=>2, "$v1"=>3, "$t8"=>24, "$t9"=>25, "$k0"=>26, "$k1"=>27, "$gp"=>28,
                       "$sp"=>29, "$fp"=>30, "$ra"=>31, "$t0"=>8, "$t1"=>9, "$t2"=>10, "$t3"=>11, "$t4"=>12, "$t5"=>13, "$t6"=>14, "$t7"=>15, "$a0"=>4,
                       "$a1"=>5, "$a2"=>6, "$a3"=>7, "$s0"=>16, "$s1"=>17, "$s2"=>18, "$s3"=>19, "$s4"=>20, "$s5"=>21, "$s6"=>22, "$s7"=>23}

  @@aluControl = {"add" => "0010", "sub" => "0110", "and" => "0000", "or" => "0001", "slt" => "0111"}


  def self.RtypeSignals(binary, function)

    if(function == "jr")
      @@controlSignals[:regdst] = "0"
    else
      @@controlSignals[:regdst] = "1"
    end

    @@controlSignals[:branch] = "0"
    @@controlSignals[:memwrite] = "0"
    @@controlSignals[:memread] = "0"
    @@controlSignals[:regwrite] = "1"
    @@controlSignals[:memtoreg] = "0"
    @@controlSignals[:jump] = "0"
    @@controlSignals[:alusrc] = "0"
    if(@@aluControl.include? function)
    @@controlSignals[:aluop] = @@aluControl.fetch function
    else
      @@controlSignals[:aluop] = "0000"
    end

  end

  def self.rEncoder command
    stripped = command.strip.split
    shifting = false


    if (stripped[0] == "sll" || stripped[0] == "srl")
      opcode = @@opCodes.fetch(stripped[0].intern)
      rd = @@registerNumbers.fetch stripped[1].strip[0..2]
      rs = "00000"
      rt = @@registerNumbers.fetch stripped[2].strip[0..2]
      shamt = stripped[3].strip.to_s(2)
      function = @@functionCodes.fetch(stripped[0])
      binary = opcode + rs + signExtend(rt.to_s(2) , 5) + signExtend(rd.to_s(2) , 5) + signExtend(shamt , 5) + function

    elsif (stripped[0] == "jr")
      opcode = @@opCodes.fetch(stripped[0].intern)
      rd = "00000"
      rs = @@registerNumbers.fetch stripped[1].strip[0..2]
      rt = "00000"
      function = @@functionCodes.fetch(stripped[0])
      shamt = "00000"
      binary = opcode + signExtend(rs.to_s(2),5) + rt + rd + shamt + function

    else
      opcode = @@opCodes.fetch(stripped[0].intern)
      rd = @@registerNumbers.fetch stripped[1].strip[0..2]
      rs = @@registerNumbers.fetch stripped[2].strip[0..2]
      rt = @@registerNumbers.fetch stripped[3].strip[0..2]
      function = @@functionCodes.fetch(stripped[0])
      shamt = "00000"
      binary = opcode + signExtend(rs.to_s(2) , 5) + signExtend(rt.to_s(2) , 5) + signExtend(rd.to_s(2) , 5) + shamt + function
    end
    RtypeSignals(binary , stripped[0])
    return binary
  end


  def self.iEncoder (command, pc)
    data = ["lw","sw","lb","lbu","sb"]
    stripped = command.strip.split
    opcode = @@opCodes.fetch(stripped[0].intern)
    if(stripped[0] == "beq" || stripped[0] == "bne")
      rs = @@registerNumbers.fetch stripped[1].strip[0..2]
      rt = @@registerNumbers.fetch stripped[2].strip[0..2]
      address = stripped[3].strip.to_i * 4 + pc
      binary = opcode + signExtend(rs.to_s(2) , 5) + signExtend(rt.to_s(2) , 5) + signExtend(address.to_s(2) , 16)

    elsif(stripped[0] == "addi")
      rs = @@registerNumbers.fetch stripped[1].strip[0..2]
      rt = @@registerNumbers.fetch stripped[2].strip[0..2]

    elsif(stripped[0] == "lui")
      rt = @@registerNumbers.fetch stripped[1].strip[0..2]
      address = stripped[2].strip.to_i * 4 + pc
      rs = "00000"
      binary = opcode + rs + signExtend(rt.to_s(2) , 5) + signExtend(address.to_s(2) , 16)

    elsif(data.include? stripped[0])
      rt = @@registerNumbers.fetch stripped[1].strip[0..2]
      rs = @@registerNumbers.fetch stripped[2].strip[2..-2]
      address = stripped[2][0].to_i * 4 + pc
      binary = opcode + signExtend(rs.to_s(2) , 5) + signExtend(rt.to_s(2) , 5) + signExtend(address.to_s(2) , 16)
    end

    return "i" + binary
  end

  def self.jEncoder command
    stripped = command.strip.split

    opcode = @@opCodes.fetch(stripped[0].intern)
    address = stripped[1].to_i * 4
    binary = opcode + signExtend(address.to_s(2) , 26)
    return "j"+ binary
  end


  def self.signExtend(string , total)
    i = string.length
    while(i<total)
      string = "0" + string
      i+=1
    end
    return string
  end

  def self.printHash
    print @@controlSignals
  end

end

# puts ControlUnit.rEncoder("jr $t1")
puts  ControlUnit.printHash
