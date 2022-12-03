LUA = lua

.PHONY: all
all:
	@git ls-files '*.lua' | while read f; do \
	  $(LUA) $$f < $$(dirname $$f)/input > $${f%.lua}.output; \
	done
