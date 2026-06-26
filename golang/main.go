package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"github.com/cfranklin11/toy-robot/golang/internal/table"
)

const tableWidth int = 5
const tableHeight int = 5

func requestCommand() {
	fmt.Println("Please enter a command: PLACE, MOVE, LEFT, RIGHT, or REPORT")
}

func main() {
	fmt.Println("Welcome to Toy Robot!")
	_, err := table.BuildTable(tableWidth, tableHeight)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\nExiting game.", err)
		return
	}

	requestCommand()
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		command := strings.TrimSpace(scanner.Text())
		fmt.Println(command, "command received")
		requestCommand()
	}
	fmt.Fprintf(os.Stderr, "%s", scanner.Err().Error())
}
