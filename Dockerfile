# syntax=docker/dockerfile:1
FROM golang:1.19 AS build
WORKDIR /src
# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading
# them in subsequent builds if they change.
COPY go.mod ./
RUN go mod download && go mod verify
COPY . ./
# -ldflags to reduce binary size.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -ldflags '-w -s' -o /usr/local/bin/app .

FROM ubuntu:latest
COPY --from=build /usr/local/bin/app /usr/local/bin/app
CMD ["/usr/local/bin/app"]
