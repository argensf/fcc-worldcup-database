#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
TRUNCATE_DETAILS="$($PSQL "TRUNCATE games, teams")" #deletes the data

declare -A TEAM_MAP #A key-pair value map to hold the team's name and id.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  if [[ $YEAR != 'year' ]] 
  then

    WINNER_ID=${TEAM_MAP[$WINNER]}
    OPPONENT_ID=${TEAM_MAP[$OPPONENT]}
    
    #Insert Winner
    if [[ -z $WINNER_ID ]]
    then 
      INSERT_RESULT_WINNER=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      TEAM_MAP[$WINNER]=$WINNER_ID
    fi

    #Insert Opponent
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_RESULT_OPPONENT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      TEAM_MAP[$OPPONENT]=$OPPONENT_ID
    fi

    #echo "$YEAR : $WINNER : $WINNER_ID <====> $OPPONENT : $OPPONENT_ID"

    #Insert Games Result
    INSERT_RESULT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, opponent_goals, winner_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $OPPONENT_GOALS, $WINNER_GOALS)")

  fi
done




