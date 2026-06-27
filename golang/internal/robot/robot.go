package robot

type Coordinate struct {
	Value int
}

type Direction struct {
	Value string
}

type Robot struct {
	X         *Coordinate
	Y         *Coordinate
	Direction *Direction
}

func BuildRobot() (*Robot, error) {
	return &Robot{}, nil
}
