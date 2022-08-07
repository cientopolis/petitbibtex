Class {
	#name : #DoiOrgAPI,
	#superclass : #Object,
	#category : #'DOI-api'
}

{ #category : #api }
DoiOrgAPI >> get: aValidDoiUrl [
	"DoiOrgAPI new get: 'http://dx.doi.org/10.1093/ajae/aaq063'"

	| rawContents parsedContents |
	self class ensureBibtexMimeTypeIsNotBinary.
	rawContents := ZnClient new
		accept: 'application/x-bibtex';
		get: aValidDoiUrl.
	parsedContents := PPBibtexParser new end parse: rawContents.
	parsedContents isPetitFailure
		ifTrue: [ ^ nil ].
	^ parsedContents first
]
