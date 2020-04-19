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

type OperationTestCase struct {
	path   string
	result int
}

func TestSumWorks(t *testing.T) {
	var sumTestCases = []OperationTestCase{
		{"/0/0", 0},
		{"/1/0", 1},
		{"/0/1", 1},
		{"/1/1", 2},
		{"/2/3", 5},
		{"/-2/1", -1},
	}

	for _, tc := range sumTestCases {
		t.Run(fmt.Sprintf("GET to /calc/%s%s return %d", "sum", tc.path, tc.result), func(t *testing.T) {
			OperationWorks(t, "sum", tc.path, tc.result)
		})
	}
}

func TestSubWorks(t *testing.T) {
	var subTestCases = []OperationTestCase{
		{"/0/0", 0},
		{"/1/0", 1},
		{"/0/1", -1},
		{"/1/1", 0},
		{"/2/3", -1},
		{"/-2/1", -3},
	}

	for _, tc := range subTestCases {
		t.Run(fmt.Sprintf("GET to /calc/%s%s return %d", "sub", tc.path, tc.result), func(t *testing.T) {
			OperationWorks(t, "sub", tc.path, tc.result)
		})
	}
}

func TestMulWorks(t *testing.T) {
	var mulTestCases = []OperationTestCase{
		{"/0/0", 0},
		{"/1/0", 0},
		{"/0/1", 0},
		{"/1/1", 1},
		{"/2/3", 6},
		{"/-2/1", -2},
	}

	for _, tc := range mulTestCases {
		t.Run(fmt.Sprintf("GET to /calc/%s%s return %d", "mul", tc.path, tc.result), func(t *testing.T) {
			OperationWorks(t, "mul", tc.path, tc.result)
		})
	}
}

func TestDivWorks(t *testing.T) {
	var divTestCases = []OperationTestCase{
		{"/0/0", 0},
		{"/1/0", 0},
		{"/0/1", 0},
		{"/1/1", 1},
		{"/2/3", 0},
		{"/-2/1", -2},
	}

	for _, tc := range divTestCases {
		t.Run(fmt.Sprintf("GET to /calc/%s%s return %d", "div", tc.path, tc.result), func(t *testing.T) {
			OperationWorks(t, "div", tc.path, tc.result)
		})
	}
}

func OperationWorks(t *testing.T, operation string, path string, result int) {
	memory := make([]func() int, 0)
	request, _ := http.NewRequest("GET", "/calc/"+operation+path, nil)
	writer := httptest.NewRecorder()

	router := mux.NewRouter()
	router.HandleFunc(fmt.Sprintf("/calc/%s/{a}/{b}", operation), OperationHandler(&memory, operation, Operations()[operation]))
	router.ServeHTTP(writer, request)

	response := writer.Result()
	defer response.Body.Close()
	body, _ := ioutil.ReadAll(response.Body)
	var payload OperationResponse
	if json.Unmarshal([]byte(body), &payload) != nil {
		assert.FailNow(t, "The payload type should OperationResponse")
	}

	assert.Equal(t, result, payload.Result)
	assert.Equal(t, http.StatusOK, response.StatusCode)
}

func TestOperationIsPesistedInMemoryBeforeItsExecution(t *testing.T) {
	memory := make([]func() int, 0)
	operations := Operations()
	router := mux.NewRouter()
	router.HandleFunc("/calc/sum/{a}/{b}", OperationHandler(&memory, "sum", operations["sum"]))
	router.HandleFunc("/calc/div/{a}/{b}", OperationHandler(&memory, "div", operations["div"]))
	router.Use(contentTypeMiddleware)

	sumHttpRequest, _ := http.NewRequest("GET", "/calc/sum/2/3", nil)
	divHttpRequest, _ := http.NewRequest("GET", "/calc/div/50/2", nil)
	writer := httptest.NewRecorder()
	router.ServeHTTP(writer, sumHttpRequest)
	router.ServeHTTP(writer, divHttpRequest)

	assert.Equal(t, 2, len(memory))
}

func TestHistoryReturnsAllOperationsDoneInThePast(t *testing.T) {
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
