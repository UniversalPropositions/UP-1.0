## Portuguese Universal Propositions

The Portuguese UP is built on top of the universal dependency treebank for Portuguese, 
version 1.4: https://github.com/UniversalDependencies/UD_Portuguese-Bosque 
It inherites their licence and file structure. 

There are three files in CoNLL-U format: A train, a test and a dev split of 
annotated data. Like all UPs, the Portuguese UP adds a layer of semantic role 
labeling annotations based on the English Proposition Bank to the treebank. 
These are added as additional columns to the CoNLL format, as in earlier
practice  with the CoNLL-X format. 

In addition, there are a list of verb overview files, one for each Portuguese verb. 
They indicate what frames a Portuguese verb can take and give examples. They are 
meant to be viewed in a browser. 

## Changes to Portuguese UD

We are currently making no changes to the underlying UD for Portuguese.

## Known issues

- We believe the recall for raised arguments to be low for Portuguese.
- For Portuguese, we did not yet execute the curation approach of our COLING 2016 paper and used heuristic frame aliasing instead. This approach favors frame recall at the cost of precision.


## Merging UP and UD datasets

step-by-step proceduce for merging UD data (branch master of
http://github.com/universaldependencies/UD_Portuguese-Bosque, called
UD collection) with the data in this directory (called UP collection).

1. rename the `*.conllu` files in this directory to `*.conll`
   files. This is the UP collection.

2. execute fix.sh to transform and copy the content of the conll files
   to CoNLL-U valid files.

3. Execute the `main` function in the merge.lisp (you will need SBCL
   and the cl-conllu library, version 0.6 or above, that can be
   installed with quicklisp).

4. The files `*.new` are the new files produced from the UD files with
   the extra SRL annotations from the UP files.

5. After double-check the files, rename the `*.new` files to `*.conllu` files:

   ```
   % for f in *.new; do mv $f $(basename $f .new); done
   ```


We had 10 sentences without the `text` metadata field. 

```
% awk '$0 ~ /sent_id/ {sent=$0} $0 ~ /# text = $/ {print FILENAME,sent,$0}' *.conllu
pt_bosque-up-dev.conllu # sent_id = CF467-8 # text =
pt_bosque-up-dev.conllu # sent_id = CF40-4 # text =
pt_bosque-up-dev.conllu # sent_id = CF330-3 # text =
pt_bosque-up-dev.conllu # sent_id = CP662-3 # text =
pt_bosque-up-dev.conllu # sent_id = CP639-7 # text =
pt_bosque-up-dev.conllu # sent_id = CP896-3 # text =
pt_bosque-up-dev.conllu # sent_id = CF168-10 # text =
pt_bosque-up-dev.conllu # sent_id = CP831-5 # text =
pt_bosque-up-dev.conllu # sent_id = CP170-1 # text =
pt_bosque-up-test.conllu # sent_id = CP999-2 # text =
```

sentence level mismatches:

```
% grep propbank *.conllu | sort | uniq -c
   6 pt_bosque-up-test.conllu:# propbank = diff-number-tokens
 107 pt_bosque-up-train.conllu:# propbank = diff-number-tokens
   5 pt_bosque-up-train.conllu:# propbank = no-up
   2 pt_bosque-up-train.conllu:# propbank = not-in-ud
```

Token level mismatches (the binary masc encodes if the upostag, head
or deprel fields are equal (1) or different (0):

```
% gawk '$0 ~ /sent_id/ {sent=$0} $1 ~ /^[0-9]+$/ {match($10,/Match=([01]{3})/,a); print FILENAME,a[1];}' *.new  | sort | uniq -c | sort -nr
149628 pt_bosque-up-train.conllu.new 111
29585 pt_bosque-up-train.conllu.new 110
8094 pt_bosque-up-dev.conllu.new 111
7147 pt_bosque-up-test.conllu.new 111
5623 pt_bosque-up-train.conllu.new 011
4919 pt_bosque-up-train.conllu.new 101
4255 pt_bosque-up-train.conllu.new 001
4205 pt_bosque-up-train.conllu.new 100
3998 pt_bosque-up-train.conllu.new
2359 pt_bosque-up-train.conllu.new 000
2177 pt_bosque-up-train.conllu.new 010
1680 pt_bosque-up-dev.conllu.new 110
1468 pt_bosque-up-test.conllu.new 110
 297 pt_bosque-up-test.conllu.new 011
 297 pt_bosque-up-dev.conllu.new 011
 291 pt_bosque-up-test.conllu.new 101
 259 pt_bosque-up-test.conllu.new 100
 238 pt_bosque-up-test.conllu.new
 205 pt_bosque-up-dev.conllu.new 001
 200 pt_bosque-up-dev.conllu.new 100
 193 pt_bosque-up-dev.conllu.new 101
 180 pt_bosque-up-test.conllu.new 010
 175 pt_bosque-up-test.conllu.new 001
 145 pt_bosque-up-test.conllu.new 000
 101 pt_bosque-up-dev.conllu.new 000
  81 pt_bosque-up-dev.conllu.new 010
```
