class ControlUnit

  @@controlSignals = {:regdst => "0", :branch => "0", :memwrite => "0", :memread => "0", :regwrite => "0", :memtoreg => "0",
  :jump => "0",  :alusrc => "0", :aluop => "0"}

  @@opCodes = {:lw =>"100011", :lb =>"100000", :lbu =>"100100", :sw =>"101011", :sb =>"101000", :lui =>"001111", :beq =>"000100",
    :bne =>"000101", :addi =>"001000", :add =>"000000", :sub =>"000000", :nor =>"000000", :and =>"000000", :slt =>"000000",
  :sltu =>"000000", :sll =>"000000", :srl =>"000000", :jr =>"000000", :j =>"000010", :jal=>"000011"}

  @@functionCodes = {"add"=>"100000", "sub"=>"100010", "nor"=>"100111", "and"=>"100100", "slt"=>"101010", "sltu"=>"101011",
  "sll"=>"000000", "srl"=>"000010", "jr"=>"001000"}

  @@registerNumbers = {"$zero"=>0, "$0"=>0, "$at"=>1, "$v0"=>2, "$v1"=>3, "$t8"=>24, "$t9"=>25, "$k0"=>26, "$k1"=>27, "$gp"=>28,
    "$sp"=>29, "$fp"=>30, "$ra"=>31, "$t0"=>8, "$t1"=>9, "$t2"=>10, "$t3"=>11, "$t4"=>12, "$t5"=>13, "$t6"=>14, "$t7"=>15, "$a0"=>4,
  "$a1"=>5, "$a2"=>6, "$a3"=>7, "$s0"=>16, "$s1"=>17, "$s2"=>18, "$s3"=>19, "$s4"=>20, "$s5"=>21, "$s6"=>22, "$s7"=>23}

  @@aluControl = {"add" => "0010", "sub" => "0110", "and" => "0000", "or" => "0001", "slt" => "0111"}


  def self.rtypeSignals function

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


  def self.itypeSignals function
    @@controlSignals[:regdst] = "0"
    @@controlSignals[:jump] = "0"

    case function
    when "beq" , "bne"
      @@controlSignals[:branch] = "1"
      @@controlSignals[:memwrite] = "0"
      @@controlSignals[:memread] = "0"
      @@controlSignals[:regwrite] = "0"
      @@controlSignals[:memtoreg] = "1"
      @@controlSignals[:alusrc] = "0"
    when "lw", "lb" , "lbu"
      @@controlSignals[:branch] = "0"
      @@controlSignals[:memwrite] = "0"
      @@controlSignals[:memread] = "1"
      @@controlSignals[:regwrite] = "1"
      @@controlSignals[:memtoreg] = "0"
      @@controlSignals[:alusrc] = "1"
    when "sw" , "sb"
      @@controlSignals[:branch] = "0"
      @@controlSignals[:memwrite] = "1"
      @@controlSignals[:memread] = "0"
      @@controlSignals[:regwrite] = "0"
      @@controlSignals[:memtoreg] = "1"
      @@controlSignals[:alusrc] = "1"
    when "addi"
      @@controlSignals[:branch] = "0"
      @@controlSignals[:memwrite] = "0"
      @@controlSignals[:memread] = "0"
      @@controlSignals[:regwrite] = "1"
      @@controlSignals[:memtoreg] = "1"
      @@controlSignals[:alusrc] = "0"
    when "lui"
      @@controlSignals[:branch] = "0"
      @@controlSignals[:memwrite] = "0"
      @@controlSignals[:memread] = "1"
      @@controlSignals[:regwrite] = "1"
      @@controlSignals[:memtoreg] = "0"
      @@controlSignals[:alusrc] = "1"
    end

    if(@@aluControl.include? function)
      @@controlSignals[:aluop] = @@aluControl.fetch function
    else
      @@controlSignals[:aluop] = "0000"
    end

  end



  def self.jtypeSignals
    @@controlSignals[:regdst] = "0"
    @@controlSignals[:jump] = "1"
    @@controlSignals[:branch] = "0"
    @@controlSignals[:memwrite] = "0"
    @@controlSignals[:memread] = "0"
    @@controlSignals[:regwrite] = "0"
    @@controlSignals[:memtoreg] = "0"
    @@controlSignals[:alusrc] = "0"
    @@controlSignals[:aluop] = "0000"

  end





  def self.rEncoder command
      stripped = command.strip.split

      if (stripped[0] == "sll" || stripped[0] == "srl")
          opcode = @@opCodes.fetch(stripped[0].intern)
          rd = @@registerNumbers.fetch stripped[1].strip[0..2]
          rs = "00000"
          rt = @@registerNumbers.fetch stripped[2].strip[0..2]
          shamt = stripped[3].strip.to_s(2)
          function = @@functionCodes.fetch(stripped[0])
          binary = opcode + rs + zeroExtend(rt.to_s(2) , 5) + zeroExtend(rd.to_s(2) , 5) + zeroExtend(shamt , 5) + function

      elsif (stripped[0] == "jr")
          opcode = @@opCodes.fetch(stripped[0].intern)
          rd = "00000"
          rs = @@registerNumbers.fetch stripped[1].strip[0..2]
          rt = "00000"
          function = @@functionCodes.fetch(stripped[0])
          shamt = "00000"
          binary = opcode + zeroExtend(rs.to_s(2),5) + rt + rd + shamt + function

      else
          opcode = @@opCodes.fetch(stripped[0].intern)
          rd = @@registerNumbers.fetch stripped[1].strip[0..2]
          rs = @@registerNumbers.fetch stripped[2].strip[0..2]
          rt = @@registerNumbers.fetch stripped[3].strip[0..2]
          function = @@functionCodes.fetch(stripped[0])
          shamt = "00000"
          binary = opcode + zeroExtend(rs.to_s(2) , 5) + zeroExtend(rt.to_s(2) , 5) + zeroExtend(rd.to_s(2) , 5) + shamt + function
      end
      rtypeSignals stripped[0]

  end


  def self.iEncoder (command, pc)
      stripped = command.strip.split
      opcode = @@opCodes.fetch(stripped[0].intern)

      case stripped[0]
      when "beq" , "bne"
          rs = @@registerNumbers.fetch stripped[1].strip[0..2]
          rt = @@registerNumbers.fetch stripped[2].strip[0..2]
          address = stripped[3].strip.to_i * 4 + pc
          binary = opcode + zeroExtend(rs.to_s(2) , 5) + zeroExtend(rt.to_s(2) , 5) + zeroExtend(address.to_s(2) , 16)

      when "addi"
          rs = @@registerNumbers.fetch stripped[2].strip[0..2]
          rt = @@registerNumbers.fetch stripped[1].strip[0..2]

          address = stripped[3].to_i

          binary = opcode + zeroExtend(rs.to_s(2) , 5) + zeroExtend(rt.to_s(2) , 5) + signExtend(address.to_s(2) , 16)

      when "lui"
          rs = "00000"
          rt = @@registerNumbers.fetch stripped[1].strip[0..2]
          address = stripped[2].to_i
          binary = opcode + rs + zeroExtend(rt.to_s(2) , 5) + zeroExtend(address.to_s(2) , 16)

      when "lw","sw","lb","lbu","sb"
          rt = @@registerNumbers.fetch stripped[1].strip[0..2]
          rs = @@registerNumbers.fetch stripped[2].strip[2..-2]
          address = stripped[2][0].to_i * 4 + pc
          binary = opcode + zeroExtend(rs.to_s(2) , 5) + zeroExtend(rt.to_s(2) , 5) + zeroExtend(address.to_s(2) , 16)
      end
      itypeSignals stripped[0]
  end

  def self.jEncoder command
      stripped = command.strip.split

      opcode = @@opCodes.fetch(stripped[0].intern)
      address = stripped[1].to_i * 4
      binary = opcode + zeroExtend(address.to_s(2) , 26)
      jtypeSignals
  end



  def self.signExtend(binary,total)
      i = binary.length
      filler = binary[0]
      for i in binary.length..total
          binary = filler + binary
      end

      return binary
  end

  def self.zeroExtend(binary , total)
      i = binary.length

      while (i< total)
          binary = "0" + binary
          i +=1
      end
      return binary
  end

    def self.printHash
        print @@controlSignals
    end

    def self.negate int
        negBinary = "%b" % ~int
        withoutDots = negBinary[2..-1]
        return (withoutDots.to_i(2) + 0b1).to_s(2)
    end

end

puts  ControlUnit.signExtend((6).to_s(2), 16)
