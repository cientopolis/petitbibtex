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
	self assert: (entry at: 'title') equals: 'the title'.
	self assert: (entry at: 'absent-key') isNil
]

{ #category : #testing }
BibtexEntryTest >> testAtPut [
	entry at: 'title' put: 'new value'.
	self assert: (entry at: 'title') equals: 'new value'
]

{ #category : #testing }
BibtexEntryTest >> testUtilityAccessors [
	entry := BibtexEntry
		type: 'book'
		citationKey: 'pitts123'
		tags:
			{(BibtexTag name: 'author' value: 'the author').
			(BibtexTag name: 'editor' value: 'the editor').
			(BibtexTag name: 'abstract' value: 'the abstract').
			(BibtexTag name: 'year' value: 'the year').
			(BibtexTag name: 'title' value: 'the title')}.
	self assert: entry title equals: 'the title'.
	self assert: entry abstract equals: 'the abstract'.
	self assert: entry editor equals: 'the editor'.
	self assert: entry year equals: 'the year'.
	self assert: entry author equals: 'the author'
]
