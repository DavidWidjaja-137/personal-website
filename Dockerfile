# syntax=docker/dockerfile:1

##
## Build
##
FROM golang:alpine3.15 AS BUILD

WORKDIR /app

COPY go.mod ./
RUN go mod download
COPY ./ ./

RUN apk add --update npm
RUN npm install
RUN npm run build

RUN CGO_ENABLED=0 GOOS=linux go build personal-website

##
## Deploy
##

FROM alpine:3.15.0

WORKDIR /app
COPY --from=BUILD /app ./
EXPOSE 80

CMD ["./personal-website"]
