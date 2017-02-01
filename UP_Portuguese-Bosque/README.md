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
