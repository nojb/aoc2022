max = 0

function add(count)
   if count > max then
      max = count
   end
end

count = 0

while true do
   local line = io.read()
   if line == nil then -- end of file
      add(count)
      break
   end
   if line == "" then
      add(count)
      count = 0
   else
      count = count + tonumber(line)
   end
end

print(max)
