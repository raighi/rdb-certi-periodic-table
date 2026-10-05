#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
echo Please provide an element as an argument.
else
# Requête imbriquée du type:
# Chercher si c'est un élément avec le numéro atomique
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  ATOMIC_NUMBER_QUERY=$($PSQL "SELECT e.atomic_number, e.symbol, t.type, p.atomic_mass, e.name, p.melting_point_celsius, p.boiling_point_celsius 
  FROM elements AS e
  JOIN properties AS p ON e.atomic_number=p.atomic_number
  JOIN types AS t ON t.type_id=p.type_id
  WHERE e.atomic_number = '$1'")
    if [[ -z $ATOMIC_NUMBER_QUERY ]]
    then 
      echo I could not find that element in the database.
    else
      echo "$ATOMIC_NUMBER_QUERY" | while IFS='|' read ATOMIC_NUMBER SYMBOL TYPE ATOMIC_MASS NAME MELTING_POINT BOILING_POINT
      do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  # Si non chercher avec le symbole ou le nom
  else
  VAR_NUMBER_QUERY=$($PSQL "SELECT e.atomic_number, e.symbol, t.type, p.atomic_mass, e.name, p.melting_point_celsius, p.boiling_point_celsius 
  FROM elements AS e
  JOIN properties AS p ON e.atomic_number=p.atomic_number
  JOIN types AS t ON t.type_id=p.type_id
  WHERE e.symbol = '$1' OR e.name='$1'")
  if [[ -z $VAR_NUMBER_QUERY ]]
    then 
      echo I could not find that element in the database.
    else
      echo "$VAR_NUMBER_QUERY" | while IFS='|' read ATOMIC_NUMBER SYMBOL TYPE ATOMIC_MASS NAME MELTING_POINT BOILING_POINT
      do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  fi
  

fi