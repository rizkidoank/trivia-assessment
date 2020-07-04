package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

func getCurrentDateTrivia(w http.ResponseWriter, r *http.Request) {
	nowTimestamp := time.Now()
	currentDay := nowTimestamp.Day()
	currentMonth := nowTimestamp.Month()

	requestUrl := fmt.Sprintf("http://numbersapi.com/%d/%d/date?json", currentMonth, currentDay)

	res, err := http.Get(requestUrl)
	if err != nil {
		log.Fatalln(err)
	}
	defer res.Body.Close()

	var data map[string]interface{}

	if err:= json.NewDecoder(res.Body).Decode(&data); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Fatalln(err)
	}

	jsonData, err := json.Marshal(data)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Fatalln(err)
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(jsonData)

	log.Printf("GET / with status code %d\n", http.StatusOK)
}

func main() {
	http.HandleFunc("/", getCurrentDateTrivia)
	log.Println("Listening on port 8081")
	log.Fatal(http.ListenAndServe(":8081", nil))
}
