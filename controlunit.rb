class ControlUnit
    require './reg'

    @controlSignals = {:regdst => "0", :branch => "0", :memwrite => "0", :memread => "0", :regwrite => "0", :memtoreg => "0",
                       :jump => "0",  :alusrc => "0", :aluop => "0", :alucontrol => "0"}

    @opCodes = {:lw =>"100011", :lb =>"100000", :lbu =>"100100", :sw =>"101011", :sb =>"101000", :lui =>"001111", :beq =>"000100",
                :bne =>"000101", :addi =>"001000", :add =>"000000", :sub =>"000000", :nor =>"000000", :and =>"000000", :slt =>"000000",
                :sltu =>"000000", :sll =>"000000", :srl =>"000000", :jr =>"000000", :j =>"000010", :jal=>"000011"}

    @functionCodes = {"add"=>"100000", "sub"=>"100010", "nor"=>"100111", "and"=>"100100", "slt"=>"101010", "sltu"=>"101011",
                      "sll"=>"000000", "srl"=>"000010", "jr"=>"001000"}

    @registerNumbers = {"$zero"=>0, "$0"=>0, "$at"=>1, "$v0"=>2, "$v1"=>3, "$t8"=>24, "$t9"=>25, "$k0"=>26, "$k1"=>27, "$gp"=>28,
                        "$sp"=>29, "$fp"=>30, "$ra"=>31, "$t0"=>8, "$t1"=>9, "$t2"=>10, "$t3"=>11, "$t4"=>12, "$t5"=>13, "$t6"=>14, "$t7"=>15, "$a0"=>4,
                        "$a1"=>5, "$a2"=>6, "$a3"=>7, "$s0"=>16, "$s1"=>17, "$s2"=>18, "$s3"=>19, "$s4"=>20, "$s5"=>21, "$s6"=>22, "$s7"=>23}

    @aluControl = {"add" => "0010", "sub" => "0110", "and" => "0000", "or" => "0001", "slt" => "0111", "sltu" => "1000", "lw" => "0010", "sw" => "0010",
        "beq" => "0110", "bne" => "0110", "sll" => "0011", "srl" => "0100", "nor" => "0101", "lb" => "0010", "lbu" => "0010", "sb" => "0010",
        "lui" => "0010", "addi" => "0010"}

     # @i_format_array = ["lw", "lb", "lbu", "sw", "sb", "lui", "beq", "bne", "addi"]
     #  @r_format_array = ["add", "sub", "nor", "and", "slt", "sltu", "sll", "srl", "jr"]
     #  @j_format_array = ["j", "jal"]

    def self.get_signals command
        format = Reg.get_format command
        case format
        when 'i'
            self.itypeSignals command
        when 'r'
            self.rtypeSignals command
        when 'j'
            self.jtypeSignals
        end
    end

    def self.rtypeSignals function

        if(function == "jr")
            @controlSignals[:regdst] = "0"
        else
            @controlSignals[:regdst] = "1"
        end

        @controlSignals[:branch] = "0"
        @controlSignals[:memwrite] = "0"
        @controlSignals[:memread] = "0"
        @controlSignals[:regwrite] = "1"
        @controlSignals[:memtoreg] = "0"
        @controlSignals[:jump] = "0"
        @controlSignals[:alusrc] = "0"
        @controlSignals[:aluop] ="10"

        if(@aluControl.include? function)
            @controlSignals[:alucontrol] = @aluControl.fetch function.strip
        else
            @controlSignals[:alucontrol] = "1111"
        end
        @controlSignals
    end

    def self.itypeSignals function
        @controlSignals[:regdst] = "0"
        @controlSignals[:jump] = "0"

        case function
        when "beq" , "bne"
            @controlSignals[:branch] = "1"
            @controlSignals[:memwrite] = "0"
            @controlSignals[:memread] = "0"
            @controlSignals[:regwrite] = "0"
            @controlSignals[:memtoreg] = "0"
            @controlSignals[:alusrc] = "0"
            @controlSignals[:aluop] ="01"
        when "lw", "lb" , "lbu"
            @controlSignals[:branch] = "0"
            @controlSignals[:memwrite] = "0"
            @controlSignals[:memread] = "1"
            @controlSignals[:regwrite] = "1"
            @controlSignals[:memtoreg] = "1"
            @controlSignals[:alusrc] = "1"
            @controlSignals[:aluop] = "00"
        when "sw" , "sb"
            @controlSignals[:branch] = "0"
            @controlSignals[:memwrite] = "1"
            @controlSignals[:memread] = "0"
            @controlSignals[:regwrite] = "0"
            @controlSignals[:memtoreg] = "1"
            @controlSignals[:alusrc] = "1"
            @controlSignals[:aluop] ="00"
        when "addi"
            @controlSignals[:branch] = "0"
            @controlSignals[:memwrite] = "0"
            @controlSignals[:memread] = "0"
            @controlSignals[:regwrite] = "1"
            @controlSignals[:memtoreg] = "0"
            @controlSignals[:alusrc] = "1"
            @controlSignals[:aluop] ="11"
        when "lui"
            @controlSignals[:branch] = "0"
            @controlSignals[:memwrite] = "0"
            @controlSignals[:memread] = "1"
            @controlSignals[:regwrite] = "1"
            @controlSignals[:memtoreg] = "1"
            @controlSignals[:alusrc] = "1"
            @controlSignals[:aluop] ="11"
        end

        if(@aluControl.include? function)
            @controlSignals[:alucontrol] = @aluControl.fetch function.strip
        else
            @controlSignals[:alucontrol] = "1111"
        end
        @controlSignals
    end

    def self.jtypeSignals
        @controlSignals[:regdst] = "0"
        @controlSignals[:jump] = "1"
        @controlSignals[:branch] = "0"
        @controlSignals[:memwrite] = "0"
        @controlSignals[:memread] = "0"
        @controlSignals[:regwrite] = "0"
        @controlSignals[:memtoreg] = "0"
        @controlSignals[:alusrc] = "0"
        @controlSignals[:alucontrol] = "1111"
        @controlSignals[:aluop] ="11"
        @controlSignals
    end

    # ENCODER

    def self.encode command, pc=nil
        format = Reg.get_format command
        case format
        when 'i'
            self.iEncoder command, pc
        when 'r'
            self.rEncoder command
        when 'j'
            self.jEncoder command
        end
    end

    def self.rEncoder command
        stripped = Reg.decode command

        if (stripped[0] == "sll" || stripped[0] == "srl")
            opcode = @opCodes.fetch(stripped[0].intern)
            rd = @registerNumbers.fetch stripped[1].strip
            rs = "00000"
            rt = @registerNumbers.fetch stripped[2].strip
            shamt = stripped[3].strip.to_i.to_s(2)
            function = @functionCodes.fetch(stripped[0])
            binary = opcode + rs + zeroExtend(rt.to_s(2) , 5) + zeroExtend(rd.to_s(2) , 5) + zeroExtend(shamt , 5) + function

        elsif (stripped[0] == "jr")
            opcode = @opCodes.fetch(stripped[0].intern)
            rd = "00000"
            rs = @registerNumbers.fetch stripped[1].strip
            rt = "00000"
            function = @functionCodes.fetch(stripped[0])
            shamt = "00000"
            binary = opcode + zeroExtend(rs.to_s(2),5) + rt + rd + shamt + function

        else
            opcode = @opCodes.fetch(stripped[0].intern)
            rd = @registerNumbers.fetch stripped[1].strip
            rs = @registerNumbers.fetch stripped[2].strip
            rt = @registerNumbers.fetch stripped[3].strip
            function = @functionCodes.fetch(stripped[0])
            shamt = "00000"
            binary = opcode + zeroExtend(rs.to_s(2) , 5) + zeroExtend(rt.to_s(2) , 5) + zeroExtend(rd.to_s(2) , 5) + shamt + function
        end
        # sign = rtypeSignals stripped[0]
        binary
    end


    def self.iEncoder (command, pc)
        stripped = Reg.decode command
        opcode = @opCodes.fetch(stripped[0].intern)

        case stripped[0]
        when "beq" , "bne"
            rs = @registerNumbers.fetch stripped[1].strip
            rt = @registerNumbers.fetch stripped[2].strip
            puts "#RS: #{rs} ------ RT: #{rt}"
            address = stripped[3].strip# * 4 + pc
            # address = self.negate(address.to_i * -1) if address.to_i < 0
            address = self.get_binary(address.to_i, true)# if address.to_i < 0
            binary = opcode + zeroExtend(rs.to_s(2) , 5) + zeroExtend(rt.to_s(2) , 5) + signExtend(address , 16)

        when "addi"
            rs = @registerNumbers.fetch stripped[2].strip
            rt = @registerNumbers.fetch stripped[1].strip

            # if(stripped[3].include? "-")
            #     number = command.scan(/-\d+/)[0][1..-1]
            #     negNumber= negate number.to_i
            #     address = signExtend(negNumber, 16)

            # else
                number = stripped[3].to_i
                # address = zeroExtend(number.to_s(2),16)
                address = self.get_binary number, true
            # end

            binary = opcode + zeroExtend(rs.to_s(2) , 5) + zeroExtend(rt.to_s(2) , 5) + address

        when "lui"
            rs = "00000"
            rt = @registerNumbers.fetch stripped[1].strip
            address = stripped[2].to_i
            binary = opcode + rs + zeroExtend(rt.to_s(2) , 5) + zeroExtend(address.to_s(2) , 16)

        when "lw","sw","lb","lbu","sb"
            rt = @registerNumbers.fetch stripped[1].strip
            rs = @registerNumbers.fetch (stripped.last.scan(/#{Reg.get_rs.join "|"}/)[0])
            address = command.scan(/\s+\d+/)[0].strip.to_i

            binary = opcode + zeroExtend(rs.to_s(2) , 5) + zeroExtend(rt.to_s(2) , 5) + zeroExtend(address.to_s(2) , 16)
        end
        # sign = itypeSignals stripped[0]
        binary
    end

    def self.jEncoder command
        stripped = Reg.decode command

        opcode = @opCodes.fetch(stripped[0].intern)
        address = stripped[1].to_i# * 4
        # binary = opcode + zeroExtend(address.to_s(2) , 26)
        binary = opcode + ("%026b" % address)
        # sign = jtypeSignals
        binary
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
        print @controlSignals
    end

    def self.negate int
        negBinary = "%b" % ~int
        withoutDots = negBinary[2..-1]
        return (withoutDots.to_i(2) + 0b1).to_s(2)
    end

    def self.get_binary int, signed
        return "%016b" % int if not signed
        negative = true if int < 0
        return "%016b" % int if not negative
        i = -int
        s = "%016b" % i
        flipped = (s.length).times.map {|e|
            if s[e] == '1'
                '0'
            else
                '1'
            end
        }.join
        flipped = (1 + flipped.to_i(2)).to_s 2
    end

    def self.get_register binary
        @registerNumbers.key(binary.to_i 2)
    end

end

# puts ControlUnit.jEncoder "jal LOOP"
# puts ControlUnit.iEncoder "addi $t1, $0, 6" , 0
# puts ControlUnit.printHash
