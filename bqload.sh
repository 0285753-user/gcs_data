#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./bqload.sh <csv-bucket-name>"
    exit
fi

BUCKET=$1

SCHEMA=player_id:INTEGER,player_name:STRING,age:INTEGER,nationality:STRING,club:STRING,position:STRING,overall_rating:INTEGER,potential_rating:INTEGER,matches_played:INTEGER,goals:INTEGER,assists:INTEGER,minutes_played:INTEGER,market_value_million_eur:FLOAT,contract_years_left:INTEGER,injury_prone:BOOLEAN,transfer_risk_level:STRING

# create dataset if not exists
PROJECT=$(gcloud config get-value project)
bq --project_id $PROJECT show gcs_project || bq mk --sync gcs_project

CSVFILE=gs://${BUCKET}/fifa_player_performance_market_value.csv

bq --project_id $PROJECT load \
   --source_format=CSV \
   --ignore_unknown_values \
   --skip_leading_rows=1 \
   --schema=$SCHEMA \
   --replace \
   ${PROJECT}:gcs_project.fifa_players \
   $CSVFILE

echo "Done loading fifa_player_performance_market_value.csv into ${PROJECT}:gcs_project.fifa_players"
