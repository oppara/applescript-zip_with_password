APP := "zip_with_password.app"
# SRC := "zip_with_password.scpt"
SRC := "zip_with_password.applescript"

.PHONY: all
all:
	make clean
	osacompile -x -o $(APP) $(SRC)
	cp exclude.lst $(APP)/Contents/Resources/

.PHONY: clean
clean:
	$(RM) -r $(APP)
