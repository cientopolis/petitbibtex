Class {
	#name : #BibtexTagTest,
	#superclass : #TestCase,
	#category : #'PetitBibtex-tests'
}

{ #category : #test }
BibtexTagTest >> testNameValue [

	self assert: (BibtexTag name: 'UPPER' value:'') name equals: 'upper'.
]
