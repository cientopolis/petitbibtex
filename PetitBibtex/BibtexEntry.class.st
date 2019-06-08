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
		& (tags = anotherEntry tags)
]

{ #category : #accessing }
BibtexEntry >> citationKey [
	^ citationKey
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
BibtexEntry >> tags [
	^ tags
]

{ #category : #accessing }
BibtexEntry >> type [
	^ type
]

{ #category : #initialization }
BibtexEntry >> type: aTypeString citationKey: aKeyString tags: aCollectionOfBibtexTag [
	type := aTypeString.
	citationKey := aKeyString.
	tags := aCollectionOfBibtexTag
]
