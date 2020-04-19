package main

import (
	"encoding/json"
	"fmt"
	"github.com/gorilla/mux"
	"github.com/stretchr/testify/assert"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"
)

var operationTests = []struct {
	operation string
	input     string
	output    int
}{
	{"sum", "/0/0", 0},
	{"sum", "/1/0", 1},
	{"sum", "/0/1", 1},
	{"sum", "/1/1", 2},
	{"sum", "/2/3", 5},
	{"sum", "/-2/1", -1},
	{"sub", "/0/0", 0},
	{"sub", "/1/0", 1},
	{"sub", "/0/1", -1},
	{"sub", "/1/1", 0},
	{"sub", "/2/3", -1},
	{"sub", "/-2/1", -3},
	{"mul", "/0/0", 0},
	{"mul", "/1/0", 0},
	{"mul", "/0/1", 0},
	{"mul", "/1/1", 1},
	{"mul", "/2/3", 6},
	{"mul", "/-2/1", -2},
	{"div", "/0/0", 0},
	{"div", "/1/0", 0},
	{"div", "/0/1", 0},
	{"div", "/1/1", 1},
	{"div", "/2/3", 0},
	{"div", "/-2/1", -2},
}

func TestOperationExecutesOpereationsAndPersistReproducibleFunction(t *testing.T) {
	memory := make([]func() int, 0)
	operations := Operations()

	router := mux.NewRouter()
	for operationName, operation := range operations {
		router.HandleFunc(fmt.Sprintf("/calc/%s/{a}/{b}", operationName), OperationHandler(&memory, operationName, operation))
	}
	router.HandleFunc("/calc/history", HistoryHandler(&memory))
	router.Use(contentTypeMiddleware)

	for _, testParam := range operationTests {
		t.Run(fmt.Sprintf("%s%s", testParam.operation, testParam.input), func(t *testing.T) {
			request, _ := http.NewRequest("GET", "/calc/"+testParam.operation+testParam.input, nil)
			writer := httptest.NewRecorder()

			//handler := http.HandlerFunc(OperationHandler(&memory, testParam.operation, Operations()[testParam.operation]))
			router.ServeHTTP(writer, request)

			response := writer.Result()
			defer response.Body.Close()
			body, _ := ioutil.ReadAll(response.Body)
			var payload OperationResponse
			if json.Unmarshal([]byte(body), &payload) != nil {
				assert.FailNow(t, "The payload type should OperationResponse")
			}

			assert.Equal(t, testParam.output, payload.Result)
			assert.Equal(t, http.StatusOK, response.StatusCode)
		})
	}

	assert.Equal(t, len(operationTests), len(memory))
}

func TestHistoryContainsAllOperationsDoneInThePast(t *testing.T) {
	memory := make([]func() int, 0)
	memory = append(memory, func() int { return 1 + 1 })
	memory = append(memory, func() int { return 2 * 2 })

	request, _ := http.NewRequest("GET", "/calc/history", nil)
	writer := httptest.NewRecorder()

	handler := http.HandlerFunc(HistoryHandler(&memory))
	handler.ServeHTTP(writer, request)

	response := writer.Result()
	defer response.Body.Close()
	body, _ := ioutil.ReadAll(response.Body)
	var payload HistoryResponse
	if json.Unmarshal([]byte(body), &payload) != nil {
		assert.FailNow(t, "The payload type should HistoryResponse")
	}

	assert.Equal(t, []int{2, 4}, payload.Results)
	assert.Equal(t, http.StatusOK, response.StatusCode)
}
