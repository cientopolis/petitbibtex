Class {
	#name : #DoiToBibAPI,
	#superclass : #Object,
	#category : #'DOI-api'
}

{ #category : #utility }
DoiToBibAPI class >> ensureBibtexMimeTypeIsNotBinary [
	(ZnMimeType textSubTypeFragments includes: 'bibtex')
		ifFalse: [ ZnMimeType textSubTypeFragments add: 'bibtex' ]
]

{ #category : #api }
DoiToBibAPI >> get: aValidDoiString [
	| rawContents parsedContents |
   self class ensureBibtexMimeTypeIsNotBinary.  
	rawContents := ZnClient new
		get: 'https://www.doi2bib.org/2/doi2bib?id=' , aValidDoiString.
	parsedContents := PPBibtexParser new end parse: rawContents.
	parsedContents isPetitFailure
		ifTrue: [ ^ nil ].
	^ parsedContents first
]
