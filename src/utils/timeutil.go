package utils

import (
	"fmt"
	"time"
)

type TimeFormaterFunc func(time.Duration) string

func FormatHHMMSS(d time.Duration) string {
	seconds := int(d.Seconds()) % 60
	minutes := int(d.Minutes()) % 60
	hours := int(d.Hours())

	return fmt.Sprintf("%02dh:%02dm:%02ds", hours, minutes, seconds)
}

func FormatMMSS(d time.Duration) string {
	seconds := int(d.Seconds()) % 60
	minutes := int(d.Minutes())

	return fmt.Sprintf("%02dm:%02ds", minutes, seconds)
}
