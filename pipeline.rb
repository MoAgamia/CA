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
			array.shift
			break if arr.all? {|x| x.nil?}
		end
	end
end