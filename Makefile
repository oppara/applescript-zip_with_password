APP := "zip_with_password.app"
ZIP := "zip_with_password.zip"
SRC := "zip_with_password.applescript"

.PHONY: all
all:
	make clean
	osacompile -x -o $(APP) $(SRC)
	cp exclude.lst $(APP)/Contents/Resources/
	zip -r $(ZIP) $(APP)

.PHONY: clean
clean:
	$(RM) -r $(APP)
	$(RM) -r $(ZIP)
