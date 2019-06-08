Class {
	#name : #BibtexTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'value'
	],
	#category : #'PetitBibtex-model'
}

{ #category : #'instance creation' }
BibtexTag class >> name: aTagNameString value: aTagValueString [
	^ self new
		name: aTagNameString value: aTagValueString;
		yourself
]

{ #category : #comparing }
BibtexTag >> = anotherTag [
	^ anotherTag name = name & (anotherTag value = value)
]

{ #category : #accessing }
BibtexTag >> name [
	^ name
]

{ #category : #initialization }
BibtexTag >> name: aTagNameString value: aTagValueString [
	name := aTagNameString.
	value := aTagValueString
]

{ #category : #printing }
BibtexTag >> printOn: aStream [
	aStream
		nextPutAll: name;
		nextPutAll: ' = {';
		nextPutAll: value;
		nextPut: $}
]

{ #category : #accessing }
BibtexTag >> value [
	^ value
]

{ #category : #accessing }
BibtexTag >> value: anObject [
	value := anObject
]
