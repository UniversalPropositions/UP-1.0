# Universal Proposition Banks

These is release 1.0 of the Universal Proposition Banks. It is built upon [release 1.4 of the Universal Dependency Treebanks](https://lindat.mff.cuni.cz/repository/xmlui/handle/11234/1-1827) and inherits their [licence](https://lindat.mff.cuni.cz/repository/xmlui/page/licence-UD-1.4). We use the frame and role labels from the [English Proposition Bank](http://propbank.github.io/) version [3.0](https://github.com/propbank/propbank-documentation/blob/master/other-documentation/Description-of-PB3-changes.md).

**News (01/31/2017)**: Initial versions of Finnish, Portuguese and Spanish UP released!


## Languages

This release contains propbanks for the following languages: 

- [**Chinese UP**](https://github.com/System-T/UniversalPropositions/tree/master/UP_Chinese) - Inherits license [CC BY-NC-SA 3.0 US](http://creativecommons.org/licenses/by-nc-sa/3.0/us/) from the [Chinese Universal Treebank](https://github.com/UniversalDependencies/UD_Chinese) 

- [**Finnish UP**](https://github.com/System-T/UniversalPropositions/tree/master/Finnish) - Inherits license [CC BY-NC-SA 3.0 US](http://creativecommons.org/licenses/by-nc-sa/3.0/us/) from the [Finnish Universal Treebank](https://github.com/UniversalDependencies/UD_Finnish) 

- [**French UP**](https://github.com/System-T/UniversalPropositions/tree/master/UP_French) - Inherits license [CC BY-NC-SA 3.0 US](http://creativecommons.org/licenses/by-nc-sa/3.0/us/) from the [French Universal Treebank](https://github.com/UniversalDependencies/UD_French) 

- [**German UP**](https://github.com/System-T/UniversalPropositions/tree/master/UP_German) - Inherits license [CC BY-NC-SA 3.0 US](http://creativecommons.org/licenses/by-nc-sa/3.0/us/) from the [German Universal Treebank](https://github.com/UniversalDependencies/UD_German) 

- [**Portuguese UP**](https://github.com/System-T/UniversalPropositions/tree/master/UP_Portuguese-Bosque) - Inherits license [CC BY-NC-SA 3.0 US](http://creativecommons.org/licenses/by-nc-sa/3.0/us/) from the [Portuguese Universal Treebank](https://github.com/UniversalDependencies/UD_Portuguese-Bosque) 

- [**Spanish UP**](https://github.com/System-T/UniversalPropositions/tree/master/UP_Spanish) - Inherits license [CC BY-NC-SA 3.0 US](http://creativecommons.org/licenses/by-nc-sa/3.0/us/) from the [Spanish Universal Treebank](https://github.com/UniversalDependencies/UD_Spanish) 

## Multilingual SRL 

Using this data, we can create SRL systems that predict English PropBank labels for many different languages. See a recent demo screencast of this SRL for English, French and German [**here**](https://vimeo.com/161718580). 


## Introduction

This project aims to annotate text in different languages with a layer of "universal" semantic role labeling annotation. For this purpose, we use the frame and role labels of the English Proposition Bank to label shallow semantics in sentences in new target languages. 

For instance, consider the German sentence "Seine Arbeit wird von ehrenamtlichen Helfern und Regionalgruppen des Vereins unterstützt" (_His work is supported by volunteers and regional groupings of the association_). In CoNLL format, it looks like this, with English PropBank labels in the last two columns:

| Id | Form | POS | HeadId | Deprel | Frame | Role |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Seine | DET | 2 | det:poss | _ | _ |
| 2 | Arbeit | NOUN | 11 | nsubjpass | _ | **A1** |
| 3 | wird | AUX | 11 | auxpass | _ | _ |
| 4 | von | ADP | 6 | case | _ | _ |
| 5 | ehrenamtlichen | ADJ | 6 | amod | _ | _ |
| 6 | Helfern | NOUN | 11 | nmod | _ | **A0** |
| 7 | und | CONJ | 6 | cc | _ | _ |
| 8 | Regionalgruppen | NOUN | 6 | conj | _ | _ |
| 9 | des | DET | 10 | det | _ | _ |
| 10 | Vereins | NOUN | 8 | nmod | _ | _ |
| 11 | unterstützt | VERB | 0 | root | **[support.01](http://verbs.colorado.edu/propbank/framesets-english/support-v.html)** | _ |
| 12 | . | PUNCT | 11 | punct | _ | _ |

The German verb 'unterstützt' is labeled as evoking the '**support.01**' frame with two roles: "Seine Arbeit" (_his work_) is labeled **A1** (project being supported) and "ehrenamtlichen Helfern und Regionalgruppen des Vereins" (_volunteers and regional groupings of the association_) is labeled **A0** (the helper). 


### Format 

The universal propbank (UP) for each language consists of three files in CoNLL-U format (one for training, dev and test data). In addition, each language has a folder with verb overview files in html format. These files can be viewed in a browser and give an overview of all English frames that each target language verb can evoke. 

### Scope

Our current focus is to annotate all target language verbs with appropriate English frames. This means that the scope of frame-evoking elements is currently limited to verbs. We also do not label target language auxiliary verbs. For each universal propbank, about 90% of all verbs are currently labeled. Unlabeled verbs often convey semantics for which we either could not find an appropriate English verb, or are part of complex verb constructions which we currently do not handle. 

### A note on quality 

This is an ongoing research project in which we use a combination of data-driven methods and some post-processing to generate these resources. This means that the labels in the UPs are mostly predicted over models trained on a different domain, which affects the quality. A good example is the German verb "angeben" which in our source data was mostly used in the "brag.01" sense, but in the German UD data is mostly used in the "report.01" sense, but almost never detected as such.

## Current and future work

This is an ongoing project which we are improving along three lines: (1) We are working on adding new languages to the current release. (2) We are working to curate the data to improve the quality of SRL annotation. (3) We are looking into extending the scope of frame-evoking-elements to other types of predicates besides verbs. 


## Publications

[Generating High Quality Proposition Banks for Multilingual Semantic Role Labeling](http://alanakbik.github.io/papers/acl2015.pdf). Alan Akbik, Laura Chiticariu, Marina Danilevsky, Yunyao Li, Shivakumar Vaithyanathan and Huaiyu Zhu. *53rd Annual Meeting of the Association for Computational Linguistics* ACL 2015.

[Polyglot: Multilingual Semantic Role Labeling with Unified Labels](http://alanakbik.github.io/papers/acl2016-demo.pdf). Alan Akbik and Yunyao Li. *54th Annual Meeting of the Association for Computational Linguistics* ACL 2016.

[Towards Semi-Automatic Generation of Proposition Banks for Low-Resource Languages](http://alanakbik.github.io/papers/EMNLP-final.pdf). Alan Akbik, Vishwajeet Kumar and Yunyao Li. *2016 Conference on Empirical Methods on Natural Language Processing* EMNLP 2016.

[Multilingual Information Extraction with PolyglotIE](http://alanakbik.github.io/papers/coling2016-demo.pdf). Alan Akbik, Laura Chiticariu, Marina Danilevsky, Yonas Kbrom, Yunyao Li and Huaiyu Zhu. *26th International Conference on Computational Linguistics* COLING 2016.

[K-SRL: Instance-based Learning for Semantic Role Labeling](http://alanakbik.github.io/papers/K_SRL.pdf). Alan Akbik and Yunyao Li. *26th International Conference on Computational Linguistics* COLING 2016.

[Multilingual Aliasing for Auto-Generating Proposition Banks](http://alanakbik.github.io/papers/COLING_2016_aliasing.pdf). Alan Akbik, Xinyu Guan and Yunyao Li. *26th International Conference on Computational Linguistics* COLING 2016.




