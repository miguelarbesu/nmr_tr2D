
#!/usr/bin/env bash
DATA_DIR=$1
EXPLIST=$DATA_DIR/explist.md

for f in $(find $DATA_DIR -type f -name "title" | sort -V);
    do EXPNO=$(dirname $(dirname $(dirname $f)));
    EXPTITLE=$(cat $f)
    printf "$EXPNO\n-----\n$EXPTITLE\n\n\n" >> $EXPLIST;
    done
