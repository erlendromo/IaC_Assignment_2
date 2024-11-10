package server

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/erlendromo/gowebapp/utils"
)

const (
	CONTENT_TYPE       = "Content-Type"
	APPLICATION_JSON   = "application/json"
	METHOD_NOT_ALLOWED = "Method not allowed"
)

type Response struct {
	Message string `json:"message,omitempty"`
	Uptime  string `json:"uptime,omitempty"`
	Error   string `json:"error,omitempty"`
}

type Server struct {
	start time.Time
}

func NewServer() *Server {
	return &Server{
		start: time.Now(),
	}
}

func (s *Server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	makeHttpHandlerFunc(s, utils.FormatHHMMSS)(w, r)
}

func makeHttpHandlerFunc(s *Server, formatFunc utils.TimeFormaterFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			w.Header().Set(CONTENT_TYPE, APPLICATION_JSON)
			w.WriteHeader(http.StatusOK)

			json.NewEncoder(w).Encode(Response{
				Message: "Go web-app is live!",
				Uptime:  formatFunc(time.Since(s.start)),
			})
		default:
			w.Header().Set(CONTENT_TYPE, APPLICATION_JSON)
			w.WriteHeader(http.StatusMethodNotAllowed)

			json.NewEncoder(w).Encode(Response{
				Error: METHOD_NOT_ALLOWED,
			})
		}
	}
}
