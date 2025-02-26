Class {
	#name : #BibtexEntry,
	#superclass : #Object,
	#instVars : [
		'type',
		'citationKey',
		'tags'
	],
	#category : #'PetitBibtex-model'
}

{ #category : #'instance creation' }
BibtexEntry class >> type: aTypeString citationKey: aKeyString tags: aCollectionOfBibtexTag [
	^ self new
		type: aTypeString
			citationKey: aKeyString
			tags: aCollectionOfBibtexTag;
		yourself
]

{ #category : #comparing }
BibtexEntry >> = anotherEntry [
	^ type = anotherEntry type & (citationKey = anotherEntry citationKey)
		&
			((self tags asSortedCollection: [ :a :b | a name < b name ]) asArray
				= (anotherEntry tags asSortedCollection: [ :a :b | a name < b name ]) asArray)
]

{ #category : #'utility-accessors' }
BibtexEntry >> abstract [
	^ self at: 'abstract'
]

{ #category : #accessing }
BibtexEntry >> at: key [
	^ tags at: key asLowercase ifPresent: [ :tag | tag value ] ifAbsent: [ nil ]
]

{ #category : #accessing }
BibtexEntry >> at: key put: aValue [

	^ tags
		  at: key asLowercase
		  ifPresent: [ :tag | tag value: aValue ]
		  ifAbsent: [
			  tags
				  at: key asLowercase
				  put: (BibtexTag name: key asLowercase value: aValue) ]
]

{ #category : #'utility-accessors' }
BibtexEntry >> author [
	^ self at: 'author'
]

{ #category : #accessing }
BibtexEntry >> citationKey [
	^ citationKey
]

{ #category : #accessing }
BibtexEntry >> citationKey: aString [ 
	citationKey := aString
]

{ #category : #maitenance }
BibtexEntry >> cleanupLatexAccentsAndBraces [
	tags do: #cleanupLatexAccentsAndBraces
]

{ #category : #'utility-accessors' }
BibtexEntry >> editor [
	^self at: 'editor'
]

{ #category : #maitenance }
BibtexEntry >> fixTagNameCase [

	| tagsToFix |
	tagsToFix := tags reject: [ :tag | tag name = tag name asLowercase ].
	tagsToFix do: [ :each |
		self at: each name put: each value.
		tags removeKey: each name ]
]

{ #category : #initialization }
BibtexEntry >> initialize [
	tags := Dictionary new
]

{ #category : #maitenance }
BibtexEntry >> needsTagNameCaseFixig [

	^ (tags reject: [ :tag | tag name = tag name asLowercase ]) notEmpty
]

{ #category : #printing }
BibtexEntry >> printOn: aStream [
	aStream
		nextPut: $@;
		nextPutAll: type;
		nextPutAll: ' { ';
		nextPutAll: citationKey;
		nextPut: $,;
		cr.
	tags
		do: [ :each | 
			aStream nextPutAll: '    '.
			each printOn: aStream.
			aStream nextPut: $,.
			aStream cr ].
	aStream nextPut: $}
]

{ #category : #accessing }
BibtexEntry >> removeTag: aString [
	tags removeKey: aString asLowercase ifAbsent: [  ]
]

{ #category : #accessing }
BibtexEntry >> tags [
	^ tags values
]

{ #category : #'utility-accessors' }
BibtexEntry >> title [
	^ self at: 'title'
]

{ #category : #accessing }
BibtexEntry >> type [
	^ type
]

{ #category : #accessing }
BibtexEntry >> type: aNewType [
	type := aNewType
]

{ #category : #initialization }
BibtexEntry >> type: aTypeString citationKey: aKeyString tags: aCollectionOfBibtexTag [
	type := aTypeString.
	citationKey := aKeyString.
	aCollectionOfBibtexTag do: [ :each | tags at: each name put: each ]
]

{ #category : #'utility-accessors' }
BibtexEntry >> year [
	^ self at: 'year'
]
