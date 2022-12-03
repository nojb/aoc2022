first, second, third = 0, 0, 0

function insert(x)
   if x >= first then
      third = second
      second = first
      first = x
   elseif x >= second then
      third = second
      second = x
   elseif x >= third then
      third = x
   end
end

count = 0

while true do
   local line = io.read()
   if line == nil then -- end of file
      insert(count)
      break
   elseif line == "" then
      insert(count)
      count = 0
   else
      count = count + tonumber(line)
   end
end

print(first + second + third)
