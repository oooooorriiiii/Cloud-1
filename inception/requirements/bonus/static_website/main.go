package main

import (
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

type spaHandler struct {
	staticPath string
	indexPath  string
}

func (h spaHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	path, err := filepath.Abs(r.URL.Path)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	path = filepath.Join(h.staticPath, path)

	stats, err := os.Stat(path)
	if os.IsNotExist(err) {
		http.Error(w, "404 Not Found", http.StatusNotFound)
		return
	}

	if stats.IsDir() {
		index := filepath.Join(path, "index.html")
		if _, err := os.Stat(index); err == nil {
			http.ServeFile(w, r, index)
			return
		}
	} else if strings.HasSuffix(path, ".html") {
		http.ServeFile(w, r, path)
		return
	}

	http.FileServer(http.Dir(h.staticPath)).ServeHTTP(w, r)
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "1313"
	}

	spa := spaHandler{staticPath: "public", indexPath: "index.html"}
	http.Handle("/", spa)

	log.Printf("Starting static website server on :%s ...", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
