#!/bin/bash

# Periodic table info

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Display element message
DISPLAY_MESSAGE(){
  if [[ -z $1 ]]
  then
    echo -e "I could not find that element in the database."
  else 
    IFS='|'
    read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS <<< "$1"
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
}

  if [[ -z $1 ]]
  then
    echo -e "Please provide an element as an argument."
  else
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties LEFT JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $1")
      DISPLAY_MESSAGE $ELEMENT
    elif [[ $1 =~ ^[A-Za-z]+$ ]]
    then
      ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties LEFT JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
      DISPLAY_MESSAGE $ELEMENT
    fi

  fi
