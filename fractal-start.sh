#!/bin/bash
NUM_ROWS=63
NUM_COLUMNS=100

#TODO: add better optional arguments.
function contains() {
  for i in $2;do
    if [ $i -eq $1 ]; then
      return 0
    fi
  done

  return 1
}
function drawLine() {
  for (( column=1; column<=${NUM_COLUMNS}; column++ ));do
    if contains $column "$*";then 
      printf "1"
    else
      printf "_"
    fi
  done

  NUM_ROWS=$(( NUM_ROWS - 1 ))
  printf "\n"
}
function drawTree() {
  SIZE=$1
  BRANCH_POINTS=$2

  for (( c=0; c<${SIZE}; c++ ));do
    drawLine ${BRANCH_POINTS}
  done

  ARGUMENT_LEFT=$(echo $BRANCH_POINTS | sed -rn 's/\<[0-9]+\>/$((& + ${c}))/gp')
  ARGUMENT_RIGHT=$(echo $BRANCH_POINTS | sed -rn 's/\<[0-9]+\>/$((& - ${c}))/gp')
  
  for (( c=1; c<=${SIZE}; c++ ));do
    # TODO: Remove eval by using awk instead of sed.
    eval drawLine ${ARGUMENT_LEFT} ${ARGUMENT_RIGHT}
  done
  NEW_BRANCH_POINTS=""
  for point in ${BRANCH_POINTS};do
    NEW_BRANCH_POINTS+=" $((point + SIZE)) $((point - SIZE))" 
  done

  if (( SIZE == 16/2**n ));then
    while (( NUM_ROWS ));do
      drawLine
    done
    return 0
  fi

  SIZE=$((SIZE/2))
  drawTree ${SIZE} "${NEW_BRANCH_POINTS}" 
}

read n
n=$(( n - 1 ))
drawTree 16 "50" | tac
