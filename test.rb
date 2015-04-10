x = "j Loop"
if x.match(/^(\s*)(\w|\w{3})(\s+)(\w+)(\s*)$/)
  puts true
else
  puts false
end