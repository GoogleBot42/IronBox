cmake .
make
echo "**********************"
cd IronBox
luajit test.lua
