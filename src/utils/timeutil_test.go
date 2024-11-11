package utils

import (
	"testing"
	"time"
)

func TestTimeFormatterFunc(t *testing.T) {
	durations := []time.Duration{
		0 * time.Second,
		30 * time.Second,
		500 * time.Second,
		3700 * time.Second,
		90000 * time.Second,
	}
	t.Run("formatHHMMSS", func(t *testing.T) {
		expected := []string{
			"00h:00m:00s",
			"00h:00m:30s",
			"00h:08m:20s",
			"01h:01m:40s",
			"25h:00m:00s",
		}

		for i, d := range durations {
			if got := FormatHHMMSS(d); got != expected[i] {
				t.Errorf("formatHHMMSS(%v) = %s; want %s", d, got, expected[i])
			}
		}
	})

	t.Run("formatMMSS", func(t *testing.T) {
		expected := []string{
			"00m:00s",
			"00m:30s",
			"08m:20s",
			"61m:40s",
			"1500m:00s",
		}

		for i, d := range durations {
			if got := FormatMMSS(d); got != expected[i] {
				t.Errorf("formatMMSS(%v) = %s; want %s", d, got, expected[i])
			}
		}
	})
}
