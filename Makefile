LUA = lua

.PHONY: all
all: $(patsubst %.lua,%.output,$(wildcard */*.lua))

.PHONY: clean
clean:
	rm -f $(wildcard */*.output)

%.output: %.lua
	$(LUA) $< < $(dir $<)input > $@
