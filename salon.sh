#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SCHEDULE_MENU() {
  echo -e "\n~~~ Salon Martinis ~~~"
  if [[ $1 ]]
  then 
    echo -e "\n$1"
  fi

  echo -e "\nHere are the services we have available:"

  SERVICE_INFO=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICE_INFO" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  echo -e "\nPick number of service what do you want?"
  read SERVICE_ID_SELECTED
  
  if [[ ! $SERVICE_ID_SELECTED =~ [1-3] ]]
  then
    SCHEDULE_MENU "Please enter a valid #."
  else 
    echo "What's your phone number?"
    read CUSTOMER_PHONE
    PHONE=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'") 

    if [[ -z $PHONE ]]
    then 
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME 
      INSERT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    
    SERVICE_TYPE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'") 
    echo -e "\nWhat time would you like your appointment?"
    read SERVICE_TIME
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    INSERT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $(echo $SERVICE_TYPE at $SERVICE_TIME, $CUSTOMER_NAME | sed 's/^ //')."
  fi  
}


EXIT() {
  echo -e "\n Thank you for visting our solan, have a good day!"
}

SCHEDULE_MENU
