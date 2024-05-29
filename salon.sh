#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

EXIT() {
  echo -e "\nThank you for your patronage, goodbye.\n"
}

APPOINTMENTS_MENU(){
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$1'")

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')") 
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

    SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services")
  echo -e "$SERVICE_LIST" | while IFS='|' read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  
  echo "0) To exit"

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1 | 2 | 3 | 4 | 5)  APPOINTMENTS_MENU $SERVICE_ID_SELECTED ;;
    0) EXIT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?";;
  esac
}

echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU "Welcome to My Salon, how can I help you?"