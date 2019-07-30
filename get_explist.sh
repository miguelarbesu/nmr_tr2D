
#!/usr/bin/env bash
EXPDIR=$1
EXPLIST=$EXPDIR/explist.md

rm -f $EXPLIST;

for f in $(find $EXPDIR -type f -name "title" | sort -V);
    do
        EXPNO=$(dirname $(dirname $(dirname $f)));
        EXPTITLE=$(cat $f);
        printf "$EXPNO\n----------\n$EXPTITLE\n\n\n\n" >> $EXPLIST;
    done
