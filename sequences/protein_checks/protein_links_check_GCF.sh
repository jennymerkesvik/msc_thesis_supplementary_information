#!/bin/bash
set -eux
ok=0
na=0

>protein_links_GCF.txt
>protein_links_broken_GCF.txt

while read url
do
 if wget --spider -q "${url}"
 then
   echo "${url}" >> protein_links_GCF.txt
   ok=$((ok+1))
 else
  echo "${url}" >> protein_links_broken_GCF.txt
  na=$((na+1))
 fi
done < protein_links_all_GCF.txt

echo 'ok:$ok, na:$na'