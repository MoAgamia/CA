class Decode

  @@opCodes = {"lw"=>"100011", "lb"=>"100000", "lbu"=>"100100", "sw"=>"101011", "sb"=>"101000", "lui"=>"001111", "beq"=>"000100", "bne"=>"000101", "addi"=>"001000", "add"=>"000000", "sub"=>"000000", "nor"=>"000000", "and"=>"000000", "slt"=>"000000", "sltu"=>"000000", "sll"=>"000000", "srl"=>"000000", "jr"=>"000000", "j"=>"000010", "jal"=>"000011"}

  @@functionCodes = {"add"=>"100000", "sub"=>"000000", "nor"=>"100111", "and"=>"100100", "slt"=>"101010", "sltu"=>"101011", "sll"=>"000000", "srl"=>"000010", "jr"=>"001000"}

  @@registerNumbers = {"$zero"=>0, "$0"=>0, "$at"=>1, "$v0"=>2, "$v1"=>3, "$t8"=>24, "$t9"=>25, "$k0"=>26, "$k1"=>27, "$gp"=>28, "$sp"=>29, "$fp"=>30, "$ra"=>31, "$t0"=>8, "$t1"=>9, "$t2"=>10, "$t3"=>11, "$t4"=>12, "$t5"=>13, "$t6"=>14, "$t7"=>15, "$a0"=>4, "$a1"=>5, "$a2"=>6, "$a3"=>7, "$s0"=>16, "$s1"=>17, "$s2"=>18, "$s3"=>19, "$s4"=>20, "$s5"=>21, "$s6"=>22, "$s7"=>23}


  def self.rDecoder command
    stripped = command.strip.split
    shifting = false

    if (stripped[0] == "sll" || stripped[0] == "srl")
      shifting = true
    end

    if shifting
      opcode = @@opCodes.fetch(stripped[0])
      rd = @@registerNumbers.fetch stripped[1].strip[0..2]
      rs = "00000"
      rt = @@registerNumbers.fetch stripped[2].strip[0..2]
      shamt = stripped[3].strip.to_s(2)
      function = @@functionCodes.fetch(stripped[0])
      binary = opcode + rs + binaryFiller(rt.to_s(2) , 5) + binaryFiller(rd.to_s(2) , 5) + binaryFiller(shamt , 5) + function
    else
      opcode = @@opCodes.fetch(stripped[0])
      rd = @@registerNumbers.fetch stripped[1].strip[0..2]
      rs = @@registerNumbers.fetch stripped[2].strip[0..2]
      rt = @@registerNumbers.fetch stripped[3].strip[0..2]
      function = @@functionCodes.fetch(stripped[0])
      shamt = "00000"
      binary = opcode + binaryFiller(rt.to_s(2) , 5) + binaryFiller(rt.to_s(2) , 5) + binaryFiller(rd.to_s(2) , 5) + shamt + function
    end
  end

  def self.iDecoder command
    stripped = command.strip.split

    opcode = @@opCodes.fetch(stripped[0])
    rs = @@registerNumbers.fetch stripped[1].strip[0..2]
    rt = @@registerNumbers.fetch stripped[2].strip[0..2]
    shamt = stripped[3].strip.to_s(2)
    function = @@functionCodes.fetch(stripped[0])
    binary = opcode + rs + binaryFiller(rt.to_s(2) , 5) + #cotinue addresssing
  end

  def self.jDecoder command
    stripped = command.strip.split

    opcode = @@opCodes.fetch(stripped[0])
    binary = opcode + rs + binaryFiller(rt.to_s(2) , 5) + binaryFiller(rd.to_s(2) , 5) + binaryFiller(shamt , 5) + function
  end


  def self.binaryFiller(string , total)
    i = string.length
    while(i<total)
      string = "0" + string
      i+=1
    end
    return string
  end


end


puts Decode.rDecoder "add $t1, $t2, $t3"
