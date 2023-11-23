#!/bin/bash
mkdir -p ./logs
rm -rf ./logs/*
./build/bin/main/Ex1 > ./logs/Ex1.log
