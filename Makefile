BUILD_DIR := ./dist
APP_NAME := terminal-downloader
SOURCE_DIR := ./src
ENTRYPOINT := main.go


all: test build clean

run:
	go run $(SOURCE_DIR)/main.go ${ARG}

build:
	go build -o $(BUILD_DIR)/$(APP_NAME) $(SOURCE_DIR)/main.go

test:
	go test ${SOURCE_DIR}/...

clean:
	go clean

dist: windows linux darwin

windows:
	GOOS=windows GOARCH=386 go build -o $(BUILD_DIR)/$(APP_NAME)-windows-386.exe $(SOURCE_DIR)/main.go
	GOOS=windows GOARCH=amd64 go build -o $(BUILD_DIR)/$(APP_NAME)-windows-amd64.exe $(SOURCE_DIR)/main.go

linux:
	GOOS=linux GOARCH=386 go build -o $(BUILD_DIR)/$(APP_NAME)-linux-386 $(SOURCE_DIR)/main.go
	GOOS=linux GOARCH=amd64 go build -o $(BUILD_DIR)/$(APP_NAME)-linux-amd64 $(SOURCE_DIR)/main.go

darwin:
	GOOS=darwin GOARCH=386 go build -o $(BUILD_DIR)/$(APP_NAME)-darwin-386 $(SOURCE_DIR)/main.go
	GOOS=darwin GOARCH=amd64 go build -o $(BUILD_DIR)/$(APP_NAME)-darwin-amd64 $(SOURCE_DIR)/main.go