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

-- a H + b

function num(arg)
   return { a = 0, b = arg }
end

function add(arg1, arg2)
   return { a = arg1.a + arg2.a, b = arg1.b + arg2.b }
end

function sub(arg1, arg2)
   return { a = arg1.a - arg2.a, b = arg1.b - arg2.b }
end

function mul(arg1, arg2)
   if arg1.a == 0 then
      return { a = arg1.b * arg2.a, b = arg1.b * arg2.b }
   elseif arg2.a == 0 then
      return { a = arg1.a * arg2.b, b = arg1.b * arg2.b }
   else
      assert(nil)
   end
end

function div(arg1, arg2)
   assert(arg2.a == 0)
   return { a = arg1.a / arg2.b, b = arg1.b / arg2.b }
end

function eval(t, root)
   local function loop(name)
      if name == "humn" then
         assert(t[name].kind == "num")
         return { a = 1, b = 0}
      elseif t[name].kind == "num" then
         return num(t[name].arg)
      elseif t[name].kind == "+" then
         return add(loop(t[name].arg1), loop(t[name].arg2))
      elseif t[name].kind == "*" then
         return mul(loop(t[name].arg1), loop(t[name].arg2))
      elseif t[name].kind == "/" then
         return div(loop(t[name].arg1), loop(t[name].arg2))
      elseif t[name].kind == "-" then
         return sub(loop(t[name].arg1), loop(t[name].arg2))
      else
         assert(nil)
      end
   end
   local res1, res2 = loop(t[root].arg1), loop(t[root].arg2)
   return (res2.b - res1.b) / (res1.a - res2.a)
end

print(string.format("%d", eval(read(), "root")))
