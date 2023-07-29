#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

# Function to display the main menu with numbered list of services
MAIN_MENU() {
    if [[ $1 ]]
    then
        echo -e "\n$1"
    fi
    echo "Welcome to the Salon! How may I assist you?"

    # Display numbered list of services
    echo "Services:"
    services=$($PSQL "SELECT service_id, name FROM services")
    echo "$services" | while IFS=' | ' read service_id name
    do
        echo "$service_id) $name"
    done

    echo -e "\nPlease select a service (Enter the corresponding number):"
    read SERVICE_ID_SELECTED
}

# Function for making an appointment
SERVICE_NAME() {
   SERVICE_ID_SELECTED=$1

    echo "Enter a phone number: "
    read CUSTOMER_PHONE

    # Check if the customer exists
    existing_customer=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $existing_customer ]]; then
       echo "Enter customer name: "
       read CUSTOMER_NAME

        # Insert new customer into customers table
        $PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
        customer_id=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    else
        CUSTOMER_NAME=$existing_customer
        customer_id=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi

    echo "Enter a time: "
    read SERVICE_TIME

    # Insert appointment into appointments table
    $PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ('$customer_id', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')"

    # Output confirmation message
    selected_service=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
    echo "I have put you down for a $selected_service at $SERVICE_TIME, $CUSTOMER_NAME."
}

# Function to exit the script
exit_script() {
    echo "Thank you for using the salon appointment system. Have a great day!"
    exit 0
}

    MAIN_MENU

    case $SERVICE_ID_SELECTED in
        1) SERVICE_NAME $SERVICE_ID_SELECTED  ;;
        2) SERVICE_NAME $SERVICE_ID_SELECTED ;;
        3) SERVICE_NAME $SERVICE_ID_SELECTED ;;
        *) MAIN_MENU "Please enter a valid option." ;;
    esac

