function move(t, x)
   local T, H = t.T, t.H
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
   if math.abs(T.x - H.x) >= 2 or math.abs(T.y - H.y) >= 2 then -- need to move T
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
      if not t.visited[T.x] then
         t.visited[T.x] = {}
      end
      t.visited[T.x][T.y] = true
   end
end

function main()
   local t = {T = {x = 0, y = 0}, visited = { [0] = { [0] = true } }, H = {x = 0, y = 0}}
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
