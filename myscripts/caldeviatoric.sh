#!/usr/bin/env bash

index=$1/000
grdmath $index-s11.grd $index-s33.grd ADD = $index-s44.grd
grdmath $index-s22.grd $index-s44.grd ADD = $index-skk.grd

grdmath $index-s11.grd $index-skk.grd 3 DIV SUB = $index-s11p.grd
grdmath $index-s22.grd $index-skk.grd 3 DIV SUB = $index-s22p.grd
grdmath $index-s33.grd $index-skk.grd 3 DIV SUB = $index-s33p.grd

grdmath $index-s11p.grd 2 POW $index-s22p.grd 2 POW ADD $index-s33p.grd 2 POW ADD 2 DIV $index-s12.grd 2 POW ADD $index-s13.grd 2 POW ADD $index-s23.grd 2 POW ADD SQRT = $index-tau.grd

grdmath $index-tau.grd LOG10 = $index-log10-tau.grd

#grdmap.sh -b -1000/1000/-1000/1000 -C 1 -v 1.0 -p -6/0/0.009 -u "MPa" -c seis_inv.cpt -e erpatch.sh -e ./elatlon.sh -e ./efaults.sh -e ./emoment.sh -e ./ecoasts.sh -e ./ewharton.sh $index-log10-tau.grd 
