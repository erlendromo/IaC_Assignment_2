package main

import (
	"net/http"

	"gowebapp/server"
)

func main() {
	s := server.NewServer()
	http.ListenAndServe(":8080", s)
}
