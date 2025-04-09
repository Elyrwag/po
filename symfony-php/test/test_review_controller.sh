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

address="$1/review"
contentType="Content-Type: application/json"
w_flag="%{http_code}"

echo "TESTING REVIEW CONTROLLER"
echo "============================"
echo

# GET allReviews
expected="200"
response=$(curl -s -X GET "$address" -H "$contentType" -w "$w_flag" -o /dev/null)
printf "Testing get allReviews... "
sleep 1
compare_response "$response" "$expected"

# POST Review (add)
newReview='{"productID":4,"rating":4}'
expected="302" # because of redirect
response=$(curl -s -X POST "$address" -H "$contentType" -w "$w_flag" -o /dev/null -d "$newReview" -b cookies.txt)
printf "Testing add review... "
sleep 1
compare_response "$response" "$expected"

# GET added review
expected="200"
response=$(curl -s -X GET "$address/3" -H "$contentType" -w "$w_flag" -o /dev/null)
printf "Testing get added review... "
sleep 1
compare_response "$response" "$expected"

# PUT review (update)
updateReview='{"productID":5,"rating":5}'
expected="302" # because of redirect
response=$(curl -s -X PUT "$address/2" -H "$contentType" -w "$w_flag" -o /dev/null -d "$updateReview" -b cookies.txt)
printf "Testing update review... "
sleep 1
compare_response "$response" "$expected"

# DELETE review
expected="302" # because of redirect
response=$(curl -s -X DELETE "$address/1" -H "$contentType" -w "$w_flag" -o /dev/null -b cookies.txt)
printf "Testing delete review... "
sleep 1
compare_response "$response" "$expected"
