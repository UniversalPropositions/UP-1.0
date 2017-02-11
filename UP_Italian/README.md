## Italian Universal Propositions

The Italian UP is built on top of the universal dependency treebank for Italian, 
version 1.4: https://github.com/UniversalDependencies/UD_Italian
It inherites their licence and file structure. 

There are three files in CoNLL-U format: A train, a test and a dev split of 
annotated data. Like all UPs, the Italian UP adds a layer of semantic role 
labeling annotations based on the English Proposition Bank to the treebank. 
These are added as additional columns to the CoNLL format, as in earlier
practice  with the CoNLL-X format. 

In addition, there are a list of verb overview files, one for each Italian verb. 
They indicate what frames a Italian verb can take and give examples. They are 
meant to be viewed in a browser. 

## Changes to Italian UD

We are currently making no changes to the underlying UD for Italian.

## Known issues

- We believe the recall for raised arguments to be low for Italian.
- For Portuguese, we did not yet execute the curation approach of our COLING 2016 paper and used heuristic frame aliasing instead. This approach favors frame recall at the cost of precision.
