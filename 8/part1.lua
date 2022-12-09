function read_grid()
   local t = {}
   local i = 1
   for s in io.lines() do
      t[i] = {}
      for j = 1, string.len(s) do
         t[i][j] = tonumber(string.sub(s, j, j))
      end
      i = i + 1
   end
   return t
end

function isvisible(t, i, j)
   local vl, vr, vu, vd = true, true, true, true
   for b = 1, j - 1 do
      if t[i][j] <= t[i][b] then
         vl = false
         break
      end
   end
   for b = j + 1, #t[i] do
      if t[i][j] <= t[i][b] then
         vr = false
         break
      end
   end
   for a = 1, i - 1 do
      if t[i][j] <= t[a][j] then
         vu = false
         break
      end
   end
   for a = i + 1, #t do
      if t[i][j] <= t[a][j] then
         vd = false
         break
      end
   end
   return vl or vr or vu or vd
end

function main()
   local t = read_grid()
   local tot = 0
   for i, r in pairs(t) do
      for j, _ in pairs(r) do
         if isvisible(t, i, j) then
            tot = tot + 1
         end
      end
   end
   return tot
end

print(main())
