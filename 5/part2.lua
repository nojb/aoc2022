function top(t)
   local r = {}
   for _,v in ipairs(t) do
      table.insert(r, v[#v])
   end
   return table.concat(r)
end

function move(t, n, a, b)
   -- move n crates from a to b (in order)
   for pos = #t[a] - n + 1, #t[a] do
      table.insert(t[b], t[a][pos])
   end
   -- remove n creates from a
   for _ = 1, n do
      table.remove(t[a])
   end
end

crates = {
   {"W", "B", "D", "N", "C", "F", "J"},
   {"P", "Z", "V", "Q", "L", "S", "T"},
   {"P", "Z", "B", "G", "J", "T"},
   {"D", "T", "L", "J", "Z", "B", "H", "C"},
   {"G", "V", "B", "J", "S"},
   {"P", "S", "Q"},
   {"B", "V", "D", "F", "L", "M", "P", "N"},
   {"P", "S", "M", "F", "B", "D", "L", "R"},
   {"V", "D", "T", "R"}
}

while true do
   local s = io.read()
   if not s then break end
   local n, a, b = string.match(s, "move (%d+) from (%d+) to (%d+)")
   if n and a and b then
      n = tonumber(n)
      a = tonumber(a)
      b = tonumber(b)
      move(crates, n, a, b)
   end
end

print(top(crates))
