The German UP is built on top of the universal dependency treebank for German, 
version 1.4: https://github.com/UniversalDependencies/UD_German 
It inherites their licence and file structure. 

There are three files in CoNLL-U format: A train, a test and a dev split of 
annotated data. Like all UPs, the German UP adds a layer of semantic role 
labeling annotations based on the English Proposition Bank to the treebank. 
These are added as additional columns to the CoNLL format, as in earlier
practice  with the CoNLL-X format. 

In addition, there are a list of verb overview files, one for each German verb. 
They indicate what frames a German verb can take and give examples. They are 
meant to be viewed in a browser. 

We made some changes to the underlying treebank with regards to verb lemmas. 
This includes a number of corrections of lemmatization errors, as well as 
special treatment for verbs with separable prefixes, which we now include 
as part of the lemma. We also do not allow separable prefixes to take 
semantic roles. 

In addition, reflexive pronouns are specifically marked up the German UD. We
use this markup to ensure that no reflexive pronouns take any semantic roles. 

