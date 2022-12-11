function ifif(cond, a, b)
   if cond then return a else return b end
end

function doround(t)
   -- To avoid overflow, we reduce every worry level by the product of divisors
   -- used by every monkey; this operation leaves the modulo results invariant.
   local m = 1
   for _, x in ipairs(t) do
      m = m * x.test
   end
   for _, x in ipairs(t) do
      while next(x.items) do
         local worry = table.remove(x.items, 1)
         local arg = ifif(x.arg == "old", worry, tonumber(x.arg))
         worry = ifif(x.op == '+', worry + arg, worry * arg) % m
         table.insert(t[ifif(worry % x.test == 0, x.iftrue, x.iffalse)].items, worry)
         x.inspected = x.inspected + 1
      end
   end
end

function make(items, op, arg, test, iftrue, iffalse)
   return {items = items, op = op, arg = arg, test = test, iftrue = iftrue, iffalse = iffalse, inspected = 0}
end

function parse(lines)
   local t = {}
   repeat
      local n = assert(string.match(lines(), "(%d+)"))
      local items = {}
      for item in string.gmatch(lines(), "(%d+)") do
         table.insert(items, item)
      end
      local x, op, arg = string.match(lines(), "= (%w+) ([+*]) (%w+)")
      assert(x == "old")
      local test = string.match(lines(), "(%d+)")
      local iftrue = string.match(lines(), "(%d+)")
      local iffalse = string.match(lines(), "(%d+)")
      -- Make monkey numbers 1-based so that the resulting table is a sequence
      t[n+1] = make(items, op, arg, test, iftrue+1, iffalse+1)
   until (not (lines()))
   return t
end

function main()
   local t = parse(io.lines())
   for _ = 1, 10000 do
      doround(t)
   end
   table.sort(t, function (x, y) return x.inspected > y.inspected end)
   return t[1].inspected * t[2].inspected
end

print(main())
