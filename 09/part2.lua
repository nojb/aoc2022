function move(t, x)
   local H = t.H[1]
   if x == "L" then
      H.x = H.x - 1
   elseif x == "U" then
      H.y = H.y + 1
   elseif x == "R" then
      H.x = H.x + 1
   elseif x == "D" then
      H.y = H.y - 1
   else
      assert(nil)
   end
   local function loop(i)
      local H = t.H[i]
      local T = t.H[i + 1]
      if math.abs(T.x - H.x) < 2 and math.abs(T.y - H.y) < 2 then
         return
      end
      -- need to move T
      if T.x < H.x then
         T.x = T.x + 1
      elseif H.x < T.x then
         T.x = T.x - 1
      end
      if T.y < H.y then
         T.y = T.y + 1
      elseif H.y < T.y then
         T.y = T.y - 1
      end
      if i < #t.H - 1 then
         loop(i + 1)
      else -- i = #t.H - 1
         if not t.visited[T.x] then
            t.visited[T.x] = {}
         end
         t.visited[T.x][T.y] = true
      end
   end
   loop(1)
end

function main()
   local H = {}
   for i = 1, 10 do
      H[i] = { x = 0, y = 0 }
   end
   local t = {H = H, visited = { [0] = { [0] = true } }}
   for s in io.lines() do
      local x, n = string.match(s, "(%w) (%d+)")
      n = tonumber(n)
      for _ = 1, n do
         move(t, x)
      end
   end
   local tot = 0
   for i, v in pairs(t.visited) do
      for j, _ in pairs(v) do
         tot = tot + 1
      end
   end
   return tot
end

print(main())
