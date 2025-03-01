#!/bin/bash

# Script for sending requests to the test application.

for value in {1..20}
do
    curl -X POST -d '{"name": "item'$value'", "price": '$value'.0}' -H "Content-Type: application/json" http://localhost:8000/rest/v1/item
    sleep .2
    curl -X GET http://localhost:8000/rest/v1/item/$value
    sleep .2
done