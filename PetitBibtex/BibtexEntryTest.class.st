Class {
	#name : #BibtexEntryTest,
	#superclass : #TestCase,
	#instVars : [
		'entry'
	],
	#category : #'PetitBibtex-tests'
}

{ #category : #running }
BibtexEntryTest >> setUp [
	entry := BibtexEntry
		type: 'book'
		citationKey: 'pitts123'
		tags:
			{(BibtexTag name: 'author' value: 'the author').
			(BibtexTag name: 'title' value: 'the title')}
]

{ #category : #testing }
BibtexEntryTest >> testAt [
	self assert: (entry at: 'title') equals: 'the title'
]

{ #category : #testing }
BibtexEntryTest >> testAtPut [
	entry at: 'title' put: 'new value'.
	self assert: (entry at: 'title') equals: 'new value'
]
