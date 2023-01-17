#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e  "\n~~~Beauty salon~~~\n"

MAIN_MENU(){

  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi

  echo -e "\nDges rit shegvidzlia rom dagexmarot\n"

  SERVICES=$($PSQL "SELECT service_id, name FROM services")

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  if [[ $SERVICE_ID_SELECTED =~ ^[1-3]+$ ]]
  then
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  SERVICE_NAME_FORMATED=$(echo $SERVICE_NAME | sed 's/ |/"/')
    DAJAVSHNA 
  else
    MAIN_MENU "Gtxovt sheiyvanot tqventvis sasurveli momsaxurebis shesabamis nomeri"
  fi

}

DAJAVSHNA(){

  if [[ $1 ]]
  then
  echo -e "\n$1"
  read CUSTOMER_PHONE
  else
  echo -e "Sheiyvanet tveni televonis nomeri"
  read CUSTOMER_PHONE
  fi

  if [[ -z $CUSTOMER_PHONE ]]
  then
  DAJAVSHNA "gtxovt sheiyvanot 1 cifri mainc :)"
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_ID ]]
  then 
  # momxmareblis damateba bazashi
    echo -e "\nGtxovt sheiyvanot tqveni saxeli. "
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id='$CUSTOMER_ID'")
  CUSTOMER_NAME_FORMATED=$(echo $CUSTOMER_NAME | sed 's/ |/"/')

  echo -e "gtxovt sheiyvanot tqvenitvis sasurveli dro"
  read SERVICE_TIME
  SERVICE_TIME_FORMATED=$(echo $SERVICE_TIME | sed 's/ |/"/')

  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME' )")
  EXIT
}

EXIT(){
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME_FORMATED, $CUSTOMER_NAME_FORMATED."
}

MAIN_MENU
