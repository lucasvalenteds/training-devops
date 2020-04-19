FROM golang:1.12 AS builder

RUN go get -u github.com/golang/dep/cmd/dep

WORKDIR $GOPATH/src/assignment-7
COPY Gopkg.toml Gopkg.lock ./
RUN dep ensure --vendor-only
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o /app .

FROM scratch
COPY --from=builder /app ./
EXPOSE 8080
ENTRYPOINT ["./app"]

