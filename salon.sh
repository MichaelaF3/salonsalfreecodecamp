#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

#TABLE AND COLUMNS USED

#CUSTOMERS
#customer_id SERIAL PRIMARY KEY
#phone VARCHAR() UNIQUE
#name VARCHAR()

#APPOINTMENTS
#appointmenT_id SERIAL PRIMARY KEY
#customer_id INT FOREIGN KEY
#service_id INT FOREIGN KEY
#time VARCHAR()

#SERVICES
#service_id SERIAL PRIMARY KEY
#name VARCHAR()

echo -e "\n~~~~~ MY SALON ~~~~~\n"

#MAIN_MENU() {

#ask customer which service they would like
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
if [[ $1 ]]
then
echo -e "\n$1"
fi

#get service options
SERVICE_OPTIONS=$($PSQL "SELECT * FROM services WHERE name IS NOT NULL ORDER BY service_id")

#list service options to choose from
echo "$SERVICE_OPTIONS" | while read SERVICE_ID BAR NAME
do
if [[ ! -z $NAME && $SERVICE_ID != 'service_id' ]]
then
echo -e "$SERVICE_ID) $NAME"
fi
done

#get input from customer
  read SERVICE_ID_SELECTED
  #if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  #then
 # MAIN_MENU "Please enter the number associated with the service"
 # else

    case $SERVICE_ID_SELECTED in
      1) SERVICE_MENU 1 ;;
      2) SERVICE_MENU 2 ;;
      3) SERVICE_MENU 3 ;;
      4) SERVICE_MENU 4 ;;
      5) SERVICE_MENU 5 ;;
      *) MAIN_MENU "I could not find that service, what would you like today?" ;;
    esac
#  fi
    
}


SERVICE_MENU() {
  SERVICE_ID_SELECTED=$1
 # echo $SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  #echo $SERVICE_NAME

  echo -e "What's your phone number?"
  read CUSTOMER_PHONE
  PHONE_CHECK=$($PSQL "SELECT * FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $PHONE_CHECK ]]
    then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  fi

    echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    INSERT_NEW_APPOOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
} 

MAIN_MENU


