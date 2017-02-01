## Finnish Universal Propositions

The Finnish UP is built on top of the universal dependency treebank for Finnish, 
version 1.4: https://github.com/UniversalDependencies/UD_Finnish
It inherites their licence and file structure. 

There are three files in CoNLL-U format: A train, a test and a dev split of 
annotated data. Like all UPs, the Portuguese UP adds a layer of semantic role 
labeling annotations based on the English Proposition Bank to the treebank. 
These are added as additional columns to the CoNLL format, as in earlier
practice  with the CoNLL-X format. 

In addition, there are a list of verb overview files, one for each Finnish verb. 
They indicate what frames a Finnish verb can take and give examples. They are 
meant to be viewed in a browser. 

## Changes to Finnish UD

We are currently making no changes to the underlying UD for Finnish.

## Known issues

- We aim to compare this data to the Finnish Proposition Bank.
- We believe the recall for raised arguments to be low for Finnish.
- For Finnish, we did not yet execute the curation approach of our COLING 2016 paper and used heuristic frame aliasing instead. This approach favors frame recall at the cost of precision.
