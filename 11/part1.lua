function newmonkey(t, n, items, op, arg, test, iftrue, iffalse)
   -- Make monkey numbers 1-based so that the resulting table is a sequence
   local idx = n + 1
   assert(not t[idx])
   t[idx] =
      { n = n, items = items, op = op, arg = arg,
        test = test, iftrue = iftrue + 1, iffalse = iffalse + 1,
        inspected = 0 }
end

function ifif(cond, a, b)
   if cond then return a else return b end
end

function doround(t)
   for _, x in ipairs(t) do
      while next(x.items) do
         local worry = table.remove(x.items, 1)
         local arg = ifif(x.arg == "old", worry, tonumber(x.arg))
         worry = math.floor(ifif(x.op == '+', worry + arg, worry * arg) / 3)
         table.insert(t[ifif(worry % x.test == 0, x.iftrue, x.iffalse)].items, worry)
         x.inspected = x.inspected + 1
      end
   end
end

-- Parse a Monkey description
function parse(lines)
   local t = {}
   repeat
      local n = assert(string.match(lines(), "(%d+)"))
      local items = {}
      for item in string.gmatch(lines(), "(%d+)") do
         table.insert(items, item)
      end
      local x, op, y = string.match(lines(), "= (%w+) ([+*]) (%w+)")
      assert(x == "old")
      local test = string.match(lines(), "(%d+)")
      local iftrue = string.match(lines(), "(%d+)")
      local iffalse = string.match(lines(), "(%d+)")
      newmonkey(t, n, items, op, y, test, iftrue, iffalse)
   until (not (lines()))
   return t
end

function main()
   local t = parse(io.lines())
   for _ = 1, 20 do
      doround(t)
   end
   table.sort(t, function (x, y) return x.inspected > y.inspected end)
   return t[1].inspected * t[2].inspected
end

print(main())
