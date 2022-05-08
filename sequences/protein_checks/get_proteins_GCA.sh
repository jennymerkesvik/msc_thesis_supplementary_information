#! /bin/bash
set -eux

i=1

while read link
do
 wget $link -O protein_data_GCA/$i.faa.gz
 i=$((i+1))
done < protein_links_GCA.txt