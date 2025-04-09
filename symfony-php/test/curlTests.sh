#!/bin/bash

Success_=0
Fail_=0

Success=0
Fail=0

create_new_db() {
  rm -f "var/data.db"
  php bin/console doctrine:database:create > /dev/null
  php bin/console doctrine:migrations:migrate --no-interaction > /dev/null
}

prepare_test_env() {
    echo "Preparing test environment..."
    test_data_location="test/test_data.sql"

    if [ ! -f $test_data_location ]; then
        sleep 1
        echo "File test_data.sql doesn't exists. Aborting..."
        exit 1
    fi

    echo "Deleting old database and creating new one..."
    create_new_db
    php bin/console doctrine:query:sql "$(cat $test_data_location)" > /dev/null

    sleep 1
    echo "Old database deleted. Created new database with test data"
}

read -p "Do you want to DELETE old database and create a new one with test data (y/n)? " answer
if [[ "$answer" == "y" ]]; then
    prepare_test_env
fi

address_="http://localhost:8000"
echo "Connecting to website..."
echo
curl -s -o /dev/null -w "%{http_code}" "$address_" | grep -q "200" || { echo "Server is down!"; exit 1; }

curl -s -X POST $address_/login -d "username=admin&password=admin" -c cookies.txt > /dev/null

test_files=("test_product_controller.sh" "test_category_controller.sh" "test_review_controller.sh")
for test_file in "${test_files[@]}"; do
    source ./test/$test_file $address_
    Success_=$((Success_ + Success))
    Fail_=$((Fail_ + Fail))
    Success=0
    Fail=0
    echo
done

curl -s -X POST $address_/logout -c cookies.txt > /dev/null
rm cookies.txt

echo
echo "SUMMARY"
echo "============================"
echo "Tests succeeded: $Success_"
echo "Tests failed: $Fail_"

read -p "Do you want to clear database - DELETE and create empty database (y/n)? " answer
if [[ "$answer" == "y" ]]; then
    create_new_db
fi