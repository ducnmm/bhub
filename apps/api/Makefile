# Go parameters
GOBIN = go

.PHONY: install run clean

# Install dependencies
install:
	$(GOBIN) mod download
	$(GOBIN) install github.com/air-verse/air@v1.61.0

# Run the application with hot-reload using Air
run:
	air -c .air.toml

# Clean build artifacts
clean:
	rm -rf tmp/