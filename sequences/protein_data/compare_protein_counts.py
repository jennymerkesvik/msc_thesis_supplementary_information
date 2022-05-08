from Bio import SeqIO
import gzip as gz

with open('comparison_GCA_GCF.csv', 'w') as f:
  f.write('key;GCA;GCF;larger')

end = 3308

for i in range(1,end):
  entry = '\n'+str(i)
  GCA = list(SeqIO.parse(gz.open('protein_data/'+str(i)+'.faa.gz', 'rt'), 'fasta'))
  GCF = list(SeqIO.parse(gz.open('protein_data_GCF/'+str(i)+'.faa.gz', 'rt'), 'fasta'))

  entry += ';'+str(len(GCA))+';'+str(len(GCF))

  if len(GCA) > len(GCF): entry += ';GCA'
  elif len(GCA) < len(GCF): entry += ';GCF'
  else: entry += ';same'

  with open('comparison_GCA_GCF.csv', 'a') as f:
    f.write(entry)
