package main

import (
	"fmt"
	"os"
)

func main() {
	fmt.Println(os.Getenv("GITHUB_ACCESS_TOKEN"))
}
