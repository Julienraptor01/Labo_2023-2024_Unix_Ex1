#!/bin/bash
mkdir -p ./logs
rm -rf ./logs/*
test_number=$1
./build/bin/main/Ex1 > ./logs/Ex1.log
