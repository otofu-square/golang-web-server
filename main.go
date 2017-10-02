package main

import (
	"encoding/json"
	"os"
)

type RequestBody struct {
}

func main() {
	token := os.Getenv("LINE_CHANNEL_ACCESS_TOKEN")
	endpoint := "https://api.line.me/v2/bot/message/push"

	json.Marshal()
}
