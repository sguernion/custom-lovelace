#!/bin/bash

function get_file {
  DOWNLOAD_PATH=${2}?raw=true
  FILE_NAME=$1
  if [ "${FILE_NAME:0:1}" = "/" ]; then
    SAVE_PATH=$FILE_NAME
  else
    SAVE_PATH=$3$FILE_NAME
  fi
  TMP_NAME=${1}.tmp
  echo "Getting $1"
  # wget $DOWNLOAD_PATH -q -O $TMP_NAME
  curl -s -q -L -o $TMP_NAME $DOWNLOAD_PATH
  rv=$?
  if [ $rv != 0 ]; then
    rm $TMP_NAME
    echo "Download failed with error $rv"
    exit
  fi
  diff ${SAVE_PATH} $TMP_NAME &>/dev/null
  if [ $? == 0 ]; then
    echo "File up to date."
    rm $TMP_NAME
    return 0
  else
    mv $TMP_NAME ${SAVE_PATH}
    if [ $1 == $0 ]; then
      chmod u+x $0
      echo "Restarting"
      $0
      exit $?
    else
      return 1
    fi
  fi
}

function check_dir {
  if [ ! -d $1 ]; then
    read -p "$1 dir not found. Create? (y/n): [n] " r
    r=${r:-n}
    if [[ $r == 'y' || $r == 'Y' ]]; then
      mkdir -p $1
    else
      exit
    fi
  fi
}

if [ ! -f configuration.yaml ]; then
  echo "There is no configuration.yaml in current dir. 'update.sh' should run from Homeassistant config dir"
  read -p "Are you sure you want to continue? (y/n): [n] " r
  r=${r:-n}
  if [[ $r == 'n' || $r == 'N' ]]; then
    exit
  fi
fi

base_url=https://raw.githubusercontent.com/sguernion/custom-lovelace/master

get_file $0 $base_url/update.sh ./

check_dir "lovelace/alarm_control_panel-card"
check_dir "lovelace/beer-card"
check_dir "lovelace/bignumber-card"
check_dir "lovelace/entity-attributes-card"
check_dir "lovelace/gauge-card"
check_dir "lovelace/group-card"
check_dir "lovelace/home-setter"
check_dir "lovelace/monster-card"
check_dir "lovelace/plan-coordinates"
check_dir "lovelace/thermostat-card"


get_file alarm_control_panel-card.js $base_url/alarm_control_panel-card/alarm_control_panel-card.js lovelace/alarm_control_panel-card/
get_file beer-card.js $base_url/beer-card/beer-card.js lovelace/beer-card/
get_file bignumber-card.js $base_url/bignumber-card/bignumber-card.js lovelace/bignumber-card/
get_file entity-attributes-card.js $base_url/entity-attributes-card/entity-attributes-card.js lovelace/entity-attributes-card/
get_file gauge-card.js $base_url/gauge-card/gauge-card.js lovelace/gauge-card/
get_file group-card.js $base_url/group-card/group-card.js lovelace/group-card/
get_file home-setter.js $base_url/home-setter/home-setter.js lovelace/home-setter/
get_file monster-card.js $base_url/monster-card/monster-card.js lovelace/monster-card/
get_file plan-coordinates.js $base_url/plan-coordinates/plan-coordinates.js lovelace/plan-coordinates/
get_file thermostat-card.js $base_url/thermostat-card/thermostat-card.js lovelace/thermostat-card/
get_file thermostat-card.lib.js $base_url/thermostat-card/thermostat-card.lib.js lovelace/thermostat-card/


echo "#https://github.com/sguernion/custom-lovelace"
echo "Add in ui-lovelace.yaml : "

