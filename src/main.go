package main

import (
	"net/http"

	"github.com/erlendromo/gowebapp/server"
)

func main() {
	s := server.NewServer()
	http.ListenAndServe(":8080", s)
}
