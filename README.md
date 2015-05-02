# Perfect-Lua5.1-Sandbox
LuaJIT compatible!

Uses C debug hooks to keep unsafe lua code from running indefinitely!

NOTE: Be careful about what functions are passed to the environment of the unsafe lua code.  It is possible that C functions can be passed values that make them hang indefiniatly.  For example, if the standard lua string funcs are exposed to the unsafe code running this in the unsafe code will cause a hang: "string.find(string.rep("a", 50), string.rep("a?", 50)..string.rep("a", 50))"

This is because Lua debug hooks cannot stop C from executing.

# Compiling
On linux: run
cmake .
make
