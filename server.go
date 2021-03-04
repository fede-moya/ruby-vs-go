package main

import (
    "fmt"
    "net/http"
    b64 "encoding/base64"
)

func main() {
    http.HandleFunc("/", HelloServer)
    fmt.Println("Go server running on localhost:3001")
    http.ListenAndServe(":3001", nil)
}

func FibonacciRecursion(n int) int {
    if n <= 1 {
        return n
    }
    return FibonacciRecursion(n-1) + FibonacciRecursion(n-2)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
    // Perform costly operations
    FibonacciRecursion(23)
    sEnc := b64.StdEncoding.EncodeToString([]byte(r.URL.Path[1:]))
    fmt.Println(sEnc)
    // Repond
    fmt.Fprintf(w, "Hello, %s!", r.URL.Path[1:])
}
