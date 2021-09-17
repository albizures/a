#! /usr/bin/env zsh

LAB=""
TASK=""
TEST=""
TEST_TYPE="pos"

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package - attempt to capture frames"
      echo " "
      echo "$package [options] application [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help             show brief help"
      echo "--lab=00               specify the lab"
      echo "--task=00              specify the task"
      echo "--test=(00|all)              specify the test"
      echo "--test-type=(pos|neg)  specify the test"
      exit 0
      ;;
    --task*)
      TASK=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --lab*)
      LAB=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --test-type*)
      TEST_TYPE=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --test*)
      TEST=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done


function pad()
{
  if [[ "$1" == "" ]]
  then
    echo ""
  else
    echo $(printf "%02d\n" $1)
  fi
}

function run_with_test {
    IN_FILE=$1
    OUT_FILE=$2
    ARGS_FILE=$3

    if test -f "$IN_FILE";then
    # nothing
    else
      mkdir -p $TESTS_FOLDER
      touch $IN_FILE
    fi

    if test -f "$ARGS_FILE"; then
      ./a.out $(cat $ARGS_FILE) <$IN_FILE>$OUT_FILE
    else  
      ./a.out <$IN_FILE>$OUT_FILE
    fi
    EXIT_CODE="$?";
    cat $OUT_FILE
    echo "\n>> Exit code: $EXIT_CODE"
}


TASK=$(pad $TASK)
LAB=$(pad $LAB)
TEST=$(pad $TEST)

TASK_FOLDER=$(find . -maxdepth 1 -name "lab_${LAB}_${TASK}*")
TESTS_FOLDER="$TASK_FOLDER/func_tests"
FILE="$TASK_FOLDER/main.c"

gcc -std=c99\
    -Wall\
    -Werror\
    -Wextra\
    -Wconversion\
    -Wfloat-conversion\
    -Wredundant-decls\
    -Wpedantic\
    -Wunused\
    -Wsign-conversion\
    -Wvla\
    -pedantic\
    -Wfloat-equal ${FILE}

if [ $? -eq 0 ]; then
# nothing
else
  echo "Problems found compiling"
  return
fi

if [[ "$TEST" != "" ]]; then
  echo ">> Running with tests"
  if [[ $TEST == "all" ]]; then
    echo "not implemented"
  else
    run_with_test "${TESTS_FOLDER}/${TEST_TYPE}_${TEST}_in.txt" "${TESTS_FOLDER}/${TEST_TYPE}_${TEST}_out.txt" "${TESTS_FOLDER}/${TEST_TYPE}_${TEST}_args.txt"
  fi
else
  echo ">> Running..."
  ./a.out
fi
