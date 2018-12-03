package main

import (
	"encoding/json"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"time"
)

type Response struct {
	Files []string `json:"files"`
}

var myClient = &http.Client{Timeout: 10 * time.Second}

func getJson(url string, target interface{}) error {
	r, err := myClient.Get(url)
	if err != nil {
		return err
	}
	defer r.Body.Close()

	return json.NewDecoder(r.Body).Decode(target)
}

func downloadFile(filepath string, url string) error {

	// Create the file
	out, err := os.Create(filepath)
	if err != nil {
		return err
	}
	defer out.Close()

	// Get the data
	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	// Write the body to file
	_, err = io.Copy(out, resp.Body)
	if err != nil {
		return err
	}

	return nil
}

func main() {

	if len(os.Args) < 3 {
		panic("Invalid arguments")
	}

	path, _ := os.Getwd()
	path += "/" + os.Args[2]
	uri := os.Args[1]

	response := new(Response)
	getJson(uri, response)
	for _, file := range response.Files {
		_, fileName := filepath.Split(file)
		downloadFile(path+"/"+fileName, file)
	}
}
