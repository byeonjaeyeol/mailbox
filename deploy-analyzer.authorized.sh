docker exec goenv go build -o build/analyzer.authorized analyzer-authorized/main.go
rm ./DB-Service01/exec/analyzer.authorized/analyzer.authorized
cp ./GoEnv/go/build/analyzer.authorized ./DB-Service01/exec/analyzer.authorized/analyzer.authorized