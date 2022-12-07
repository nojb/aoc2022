function computesize(t)
   local sum = 0
   for i, v in pairs(t.entries) do
      if type(v) == "table" then -- directory
         computesize(v)
         sum = sum + v.size
      else
         sum = sum + v
      end
   end
   t.size = sum
end

function classify(s)
   if string.match(s, "^%$ ls") then
      return {kind = "ls"}
   else
      local dir = string.match(s, "^%$ cd ([%w+./]+)")
      if dir then
         return {kind = "cd", dir = dir}
      else
         local size, name = string.match(s, "^(%w+) ([%w.]+)")
         if size and name then
            return {kind = "item", size = size, name = name}
         else
            assert(nil)
         end
      end
   end
end

function build()
   fs = { entries = {} }
   cwd = fs
   for s in io.lines() do
      local x = classify(s)
      if x.kind == "cd" then
         if x.dir == "/" then
            cwd = fs
         elseif x.dir == ".." then
            cwd = cwd.parent
         else
            if not cwd.entries[x.dir] then
               cwd.entries[x.dir] = {parent = cwd, entries = {}}
            end
            cwd = cwd.entries[x.dir]
         end
      elseif x.kind == "item" then
         local size = tonumber(x.size)
         if size then -- file
            cwd.entries[x.name] = size
         else
            cwd.entries[x.name] = {parent = cwd, entries = {}}
         end
      elseif x.kind == "ls" then
      else
         assert(nil)
      end
   end
   return fs
end

function collect(accu, t)
   if t.size <= 100000 then
      table.insert(accu, t)
   end
   for i, v in pairs(t.entries) do
      if type(v) == "table" then
         collect(accu, v)
      end
   end
end

fs = build()

computesize(fs)

selected = {}

collect(selected, fs)

sum = 0

for _, v in pairs(selected) do
   sum = sum + v.size
end

print(sum)
