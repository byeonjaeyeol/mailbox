docker exec goenv go build -o build/interface_1.0.0.0 interface/src/main.go
rm ./Service01/exec/interface/interface_1.0.0.0
rm ./Service02/exec/interface/interface_1.0.0.0
cp ./GoEnv/go/build/interface_1.0.0.0 ./Service01/exec/interface/interface_1.0.0.0
cp ./GoEnv/go/build/interface_1.0.0.0 ./Service02/exec/interface/interface_1.0.0.0
