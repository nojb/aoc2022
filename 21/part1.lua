function read()
   local t = {}
   for s in io.lines() do
      local name, pos = string.match(s, "([a-z]+):()")
      local num = string.match(s, "(%d+)", pos)
      local arg1, op, arg2 = string.match(s, "([a-z]+) ([*+-/]) ([a-z]+)", pos)
      if num then
         t[name] = {kind = "num", arg = tonumber(num)}
      else
         assert(arg1 and op and arg2)
         t[name] = {kind = op, arg1 = arg1, arg2 = arg2}
      end
   end
   return t
end

function eval(t, root)
   local function loop(name)
      if t[name].kind == "num" then
         return t[name].arg
      elseif t[name].kind == "+" then
         return loop(t[name].arg1) + loop(t[name].arg2)
      elseif t[name].kind == "*" then
         return loop(t[name].arg1) * loop(t[name].arg2)
      elseif t[name].kind == "/" then
         return loop(t[name].arg1) / loop(t[name].arg2)
      elseif t[name].kind == "-" then
         return loop(t[name].arg1) - loop(t[name].arg2)
      else
         assert(nil)
      end
   end
   return loop(root)
end

print(string.format("%d", eval(read(), "root")))
