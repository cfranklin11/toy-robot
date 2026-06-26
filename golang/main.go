package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func requestCommand() {
	fmt.Println("Please enter a command: PLACE, MOVE, LEFT, RIGHT, or REPORT")
}

func main() {
	fmt.Println("Welcome to Toy Robot!")
	requestCommand()
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		command := strings.TrimSpace(scanner.Text())
		fmt.Println(command, "command received")
		requestCommand()
	}
	fmt.Fprintf(os.Stderr, "%s", scanner.Err().Error())
}
