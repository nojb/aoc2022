function check(s, n, i)
   local t = {}
   for j = i - n + 1, i do
      local c = string.byte(s, j)
      if t[c] then return false end
      t[c] = true
   end
   return true
end

function search(s, n)
   for i = n, string.len(s) do
      if check(s, n, i) then
         return i
      end
   end
end

print(search(io.read("*a"), 14))
