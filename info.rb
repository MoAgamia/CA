class Information

	attr_accessor :array

	def initialize size=5
		@size = size
		@array = Array.new size
		@array.map! { |i| i = {}}
	end

	def push hash
		@array.unshift hash
		@array.pop if @array.size > @size
	end

	def append hash, index
		@array[index].merge! hash
	end

	def replace hash, index
		@array[index][hash.keys[0]] = hash[hash.keys[0]]
	end

	def remove key, index
		@array[index].delete(key)
	end
end