LUA = lua

.PHONY: all
all: $(patsubst %.lua,%.output,$(wildcard */*.lua))

.PHONY: clean
clean:
	rm -f $(patsubst %.lua,%.output,$(wildcard */*.lua))

%.output: %.lua
	$(LUA) $< < $(dir $<)input > $@
