## Chinese Universal Propositions

The Chinese UP is built on top of the universal dependency treebank for Chinese, 
version 1.4: https://github.com/UniversalDependencies/UD_Chinese
It inherites their licence and file structure. 

There are three files in CoNLL-U format: A train, a test and a dev split of 
annotated data. Like all UPs, the Chinese UP adds a layer of semantic role 
labeling annotations based on the English Proposition Bank to the treebank. 
These are added as additional columns to the CoNLL format, as in earlier
practice  with the CoNLL-X format. 

In addition, there are a list of verb overview files, one for each Chinese verb. 
They indicate what frames a French verb can take and give examples. They are 
meant to be viewed in a browser. 

**New**: You can also directly browse the superset of 
[**Chinese verbs**](http://alanakbik.github.io/UniversalPropositions_Chinese/). 

## Known issues

The Chinese UP is currently believed to be of lower quality than the other UPs.

- Traditional vs. Simplified Chinese: Our original model is trained on simplified 
chinese, but this treebank is in traditional. For this reason, we have populated the 
LEMMA field in the conll-u format with the simplified rendering of Chinese. We treat
simplified characters therefore as "lemmas".  
- Data quality: The Chinese UD seems to be of lower quality than the other UDs 
we have looked at so far. There are a lot more parsing errors. These errors 
proparate to semantic labels. 
- Chinese verbs: There is a significant number of Chinese verbs for which we 
could not identify appropriate English verb frames. For this reason, we have 
begun projecting some noun and adjective frames from English onto Chinese verbs.
Still, recall is expected to be lower for Chinese UP compared to the other UPs.

