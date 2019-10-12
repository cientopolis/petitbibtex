Class {
	#name : #DataCiteAPI,
	#superclass : #Object,
	#category : #DOI
}

{ #category : #api }
DataCiteAPI >> get: aValidDoiString [
	| rawContents parsedContents |
	rawContents := ZnClient new
		get: 'https://api.datacite.org/dois/' , aValidDoiString.
	parsedContents := PPJsonParser new parse: rawContents.
	^ parsedContents
]
