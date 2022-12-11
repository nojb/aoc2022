LUA = lua

.PHONY: all
all: $(patsubst %.lua,%.output,$(wildcard */*.lua))

%.output: %.lua
	$(LUA) $< < $(dir $<)input > $@
