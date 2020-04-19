package main

import (
	"encoding/json"
	"fmt"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"strconv"
)

func Sum(a int, b int) func() int {
	return func() int {
		return a + b
	}
}

func Subtract(a int, b int) func() int {
	return func() int {
		return a - b
	}
}

func Multiply(a int, b int) func() int {
	return func() int {
		return a * b
	}
}

func Divide(a int, b int) func() int {
	return func() int {
		if b == 0 {
			return 0
		} else {
			return a / b
		}
	}
}

func Operations() map[string]func(int, int) func() int {
	operations := map[string]func(int, int) func() int{
		"sum": Sum,
		"sub": Subtract,
		"mul": Multiply,
		"div": Divide,
	}

	return operations
}

func contentTypeMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		next.ServeHTTP(w, r)
	})
}

type OperationResponse struct {
	Result int `json:"result"`
}

func OperationHandler(memory *[]func() int, operationName string, operation func(int, int) func() int) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		path := mux.Vars(r)
		operandA, _ := strconv.Atoi(path["a"])
		operandB, _ := strconv.Atoi(path["b"])

		operationCommand := operation(operandA, operandB)
		*memory = append(*memory, operationCommand)

		result := operationCommand()
		response := OperationResponse{Result: result}
		json.NewEncoder(w).Encode(response)

		log.Println(fmt.Sprintf("%s(%d,%d)", operationName, operandA, operandB))
	}
}

type HistoryResponse struct {
	Results []int `json:"results"`
}

func HistoryHandler(memory *[]func() int) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, t *http.Request) {
		results := make([]int, 0)

		var result int
		for _, operation := range *memory {
			result = operation()
			results = append(results, result)
		}

		response := HistoryResponse{Results: results}

		json.NewEncoder(w).Encode(response)
	}
}

func main() {
	operations := Operations()
	memory := make([]func() int, 0)

	router := mux.NewRouter()
	for operationName, operation := range operations {
		router.HandleFunc(fmt.Sprintf("/calc/%s/{a}/{b}", operationName), OperationHandler(&memory, operationName, operation))
	}
	router.HandleFunc("/calc/history", HistoryHandler(&memory))
	router.Use(contentTypeMiddleware)

	log.Fatal(http.ListenAndServe(":8080", router))
}
