run: 
	odin run src -collection:src=src

test: 
	odin test src -collection:src=src -all-packages
