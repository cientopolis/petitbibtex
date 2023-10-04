Class {
	#name : #StandalorePPBibtexParserTest,
	#superclass : #TestCase,
	#instVars : [
		'entries',
		'parser'
	],
	#category : #'PetitBibtex-tests'
}

{ #category : #running }
StandalorePPBibtexParserTest >> setUp [

	super setUp.
	
	parser := PPBibtexParser new.

	entries := { 
		           (BibtexEntry
			            type: 'type'
			            citationKey: 'pitts123'
			            tags: { 
					            (BibtexTag name: 'tag' value: '2005').
					            (BibtexTag name: 'tag' value: '2005') }).
		           (BibtexEntry
			            type: 'type'
			            citationKey: 'pitts123'
			            tags: { 
					            (BibtexTag name: 'tag' value: '2006').
					            (BibtexTag name: 'tag' value: '2006') }) } .
]

{ #category : #running }
StandalorePPBibtexParserTest >> testParseEmptyString [

	self assert: (parser parse: '') size equals: 0

]

{ #category : #running }
StandalorePPBibtexParserTest >> testParseNonEntryText [

	self assert: (parser parse: 'adsf dsf') size equals: 0.
	self assert: (parser parse: 'adsf \ndsf' withCRs ) size equals: 0.
]

{ #category : #running }
StandalorePPBibtexParserTest >> testParseStandaloneEntry [

	self assert: (parser parse: entries first printString) size equals: 1
]
