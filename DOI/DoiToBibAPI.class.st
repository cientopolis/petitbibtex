Class {
	#name : #DoiToBibAPI,
	#superclass : #Object,
	#category : #DOI
}

{ #category : #api }
DoiToBibAPI >> get: aValidDoiString [
	| rawContents parsedContents |
	(ZnMimeType textSubTypeFragments includes: 'bibtex')
		ifFalse: [ ZnMimeType textSubTypeFragments add: 'bibtex' ].
	rawContents := ZnClient new
		get: 'https://www.doi2bib.org/2/doi2bib?id=' , aValidDoiString.
	parsedContents := PPBibtexParser new parse: rawContents.
	^ parsedContents
]
