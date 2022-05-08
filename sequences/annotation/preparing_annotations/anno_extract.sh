#! bin/bash
set -eux

mkdir annotations_mod

for i in {1..3307}
do
# extract select columns from annotation output file, add to 
  name="$i"
  sed '/^#/d' annotation_output/"$name".emapper.annotations  > "$name"_tmp.csv
  awk -F'\t' '{print name"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$8"\t"$9"\t"$10"\t"$12"\t"$13"\t"$17"\t"$21}' name="$name" "$name"_tmp.csv >> annotations_mod/"$name"_tmp.csv
  echo -e 'key\tquery\tseed_ortholog\tevalue\tscore\teggNOG_OGs\tdescription\tpreferred_name\tGOs\tKEGG_ko\tKEGG_pathway\tbrite\tPFAMs' | cat - annotations_mod/"$name"_tmp.csv > annotations_mod/"$name".tsv

# remove created temp files
  rm annotations_mod/"$name"_tmp.csv
  rm "$name"_tmp.csv

# zip original file
  gzip annotation_output/"$name".emapper.annotations
done

# create directory and files for writing results to
mkdir annotation_extracts
cd ~/annotation_extracts
>COG.csv
>GO.csv
>KO.csv
cd ..

# extract columns from each modified annotation into result files
for file in annotations_mod/*.tsv
do
 #eggnog_OGs
  cut -f 1,6 $file >> annotation_extracts/COG.csv

 #GOs
  cut -f 1,9 $file >> annotation_extracts/GO.csv

 #KEGG_KOs
  cut -f 1,10 $file >> annotation_extracts/KO.csv
done

# remove duplicated rows from each result file
for file in annotation_extracts/*.csv
do
 name=$(basename "$file" .csv)
 sort $file | uniq -u > annotation_extracts/"$name"_uniques.csv
done

# insert key, corresponding to annotation file names 1-3307, for each row
# end result files: *_final.csv
for file in annotation_extracts/*_uniques.csv
do
 name=$(basename "$file" _uniques.csv)
 sed '/key/d' $file > "$name"_tmp.csv
 echo -e 'key\t'"$name" | cat - "$name"_tmp.csv > annotation_extracts/"$name"_extract.csv
 rm "$name"_tmp.csv
done