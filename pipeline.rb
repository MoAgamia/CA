class Pipeline
	def self.iterate array
		arr = []
		puts "#{array}"
		for i in 0...(5 - array.length)
			array << nil
		end
		loop do
			arr.unshift array[0]# unless array.empty?
			arr.pop if arr.length > 5 || array.empty?
			# if arr.length > 0
			puts "----------------------"
			puts "#{arr}"
			for i in (arr.length - 1).downto(0)
				case i
					when 0
						puts "fetch: #{arr[i]}"  if arr[i] != nil
					when 1
						puts "decode: #{arr[i]}"  if arr[i] != nil
					when 2
						puts "execute: #{arr[i]}"  if arr[i] != nil
					when 3
						puts "memory: #{arr[i]}"  if arr[i] != nil
					when 4
						puts "write: #{arr[i]}"  if arr[i] != nil
				end
			end
			# puts "----------------------"
			# end
			# puts "#{arr}"
			array.shift
			break if arr.all? {|x| x.nil?}
			
		end
	end
end

# Pipeline.iterate (1..10).to_a
# Pipeline.iterate ["addi $t0, $t0, 10", "add $t0, $t0, $t0", "lw $t0, 12($t0)", "sub $t1, $t0, $s0", "sw $a1, 0($s7)", "beq $s6, $0, EXT", "jal LOOP", "jr $ra"]
# Pipeline.iterate ["addi $t0, $t0, 10", "add $t0, $t0, $t0"]