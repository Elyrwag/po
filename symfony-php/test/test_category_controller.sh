#!/bin/bash

Success=0
Fail=0

compare_response() {
  response=$1
  expected=$2

  if [[ "$response" == "$expected" ]]; then
    echo "Success"
    Success=$((Success + 1))
  else
    echo "Fail"
    Fail=$((Fail + 1))
  fi
}

address="$1/category"
contentType="Content-Type: application/json"
w_flag="%{http_code}"

echo "TESTING CATEGORY CONTROLLER"
echo "============================"
echo

# GET allCategories
expected="200"
response=$(curl -s -X GET "$address" -H "$contentType" -w "$w_flag" -o /dev/null)
printf "Testing get allCategories... "
sleep 1
compare_response "$response" "$expected"

# POST Category (add)
newCategory='{"name":"New Category"}'
expected="302" # because of redirect
response=$(curl -s -X POST "$address" -H "$contentType" -w "$w_flag" -o /dev/null -d "$newCategory" -b cookies.txt)
printf "Testing add category... "
sleep 1
compare_response "$response" "$expected"

# GET added category
expected="200"
response=$(curl -s -X GET "$address/5" -H "$contentType" -w "$w_flag" -o /dev/null)
printf "Testing get added category... "
sleep 1
compare_response "$response" "$expected"

# PUT category (update)
updateCategory='{"name":"Updated Category"}'
expected="302" # because of redirect
response=$(curl -s -X PUT "$address/3" -H "$contentType" -w "$w_flag" -o /dev/null -d "$updateCategory" -b cookies.txt)
printf "Testing update category... "
sleep 1
compare_response "$response" "$expected"

# DELETE category
expected="302" # because of redirect
response=$(curl -s -X DELETE "$address/1" -H "$contentType" -w "$w_flag" -o /dev/null -b cookies.txt)
printf "Testing delete category... "
sleep 1
compare_response "$response" "$expected"
