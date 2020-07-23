APP := "zip_with_password.app"
ZIP := "zip_with_password.zip"
SRC := "zip_with_password.applescript"

.PHONY: all build release clean

all: build

build:
	make clean
	osacompile -x -o $(APP) $(SRC)
	cp exclude.lst $(APP)/Contents/Resources/

release:
	@make build
	zip -r $(ZIP) $(APP)

clean:
	$(RM) -r $(APP)
	$(RM) -r $(ZIP)
