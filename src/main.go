package main

import (
	"encoding/json"
	"net/http"
	"time"
)

type Response struct {
	Message string `json:"message"`
	Uptime  string `json:"uptime"`
}

func main() {
	start := time.Now()

	router := http.NewServeMux()
	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(Response{
				Message: "Hello, World!",
				Uptime:  time.Since(start).String(),
			})
		default:
			http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		}
	})

	http.ListenAndServe(":8080", router)
}
