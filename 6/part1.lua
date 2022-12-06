function distinct(s, i)
   local a, b, c, d = string.byte(s, i-3,i)
   return a ~= b and a ~= c and a ~= d and b ~= c and b ~= d and c ~= d
end

data = io.read("*a")

i = 4

while true do
   if distinct(data, i) then
      break
   end
   i = i + 1
end

print(i)
