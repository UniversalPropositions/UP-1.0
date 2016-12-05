# Universal Proposition Banks

These is release 0.9 of the Universal Proposition Banks. It is built opon [release 1.4 of the Universal Dependency Treebanks](https://lindat.mff.cuni.cz/repository/xmlui/handle/11234/1-1827) and inherits their [licence](https://lindat.mff.cuni.cz/repository/xmlui/page/licence-UD-1.4). We use the frame and role labels from the English Proposiiton Bank, release 1.3.


# Languages

This release contains propbanks for the following languages: 

- [**German UP**](https://github.ibm.com/akbika/up-test/tree/master/UP_German) - Inherits license [CC BY-NC-SA 3.0 US](http://creativecommons.org/licenses/by-nc-sa/3.0/us/) from the [German Universal Treebank](https://github.com/UniversalDependencies/UD_German) 

# About

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

With such data, we can create SRL systems that predict English PropBank labels for many different languages. See a recent demo screencast of this SRL for English, French and German [**here**](https://vimeo.com/161718580). 

