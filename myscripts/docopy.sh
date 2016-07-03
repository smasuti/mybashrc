#!/usr/bin/env bash

FROMDIR=$1
TODIR=$2

mkdir $TODIR
cp $FROMDIR/miracle.sh $TODIR/
cp $FROMDIR/transient.sh $TODIR/
cp $FROMDIR/bench.sh $TODIR/
cp -r $FROMDIR/faults $TODIR/
cp -r $FROMDIR/gps $TODIR/
cp $FROMDIR/miracle.in $TODIR/
cp $FROMDIR/relax.in $TODIR/
cp $FROMDIR/fields.dat $TODIR/
cp $FROMDIR/ductile.dat $TODIR/
cp $FROMDIR/prestress.dat $TODIR/
cp $FROMDIR/readme.txt $TODIR/
cp $FROMDIR/bench16.sh $TODIR/
