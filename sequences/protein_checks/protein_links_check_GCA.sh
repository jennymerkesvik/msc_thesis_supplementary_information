#!/bin/bash
set -eux
ok=0
na=0

>protein_links_GCA.txt
>protein_links_broken_GCA.txt

while read url
do
 if wget --spider -q "${url}"
 then
   echo "${url}" >> protein_links_GCA.txt
   ok=$((ok+1))
 else
  echo "${url}" >> protein_links_broken_GCA.txt
  na=$((na+1))
 fi
done < protein_links_all_GCA.txt

echo 'ok:$ok, na:$na'