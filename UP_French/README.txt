The French UP is built on top of the universal dependency treebank for French, 
version 1.4: https://github.com/UniversalDependencies/UD_French
It inherites their licence and file structure. 

There are three files in CoNLL-U format: A train, a test and a dev split of 
annotated data. Like all UPs, the French UP adds a layer of semantic role 
labeling annotations based on the English Proposition Bank to the treebank. 
These are added as additional columns to the CoNLL format, as in earlier
practice  with the CoNLL-X format. 

In addition, there are a list of verb overview files, one for each French verb. 
They indicate what frames a French verb can take and give examples. They are 
meant to be viewed in a browser. 

Known issues: 
- Negations: French negations are split into two parts ("ne.. pas"). We need 
good guidelines to annotate them.  

