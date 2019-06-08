Class {
	#name : #PPBibtexParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #'PetitBibtex-tests'
}

{ #category : #accessing }
PPBibtexParserTest >> parserClass [
	^ PPBibtexParser 
]

{ #category : #testing }
PPBibtexParserTest >> testTag [
	| tag |
	tag := BibtexTag name: 'tag' value: '2005'.
	self assert: (self parse: 'tag="2005"' rule: #tag) equals: tag.
	self assert: (self parse: 'tag={2005}' rule: #tag) equals: tag.
	self assert: (self parse: 'tag=2005' rule: #tag) equals: tag.
	self assert: (self parse: 'tag = "2005"' rule: #tag) equals: tag.
	self assert: (self parse: 'tag = {2005}' rule: #tag) equals: tag.
	self assert: (self parse: 'tag = 2005' rule: #tag) equals: tag
]

{ #category : #testing }
PPBibtexParserTest >> testTagName [
	self assert: (self parse: 'name' rule: #tagName) equals: 'name'.
	self fail: ' name ' rule: #tagName
]

{ #category : #testing }
PPBibtexParserTest >> testTagValue [
	self assert: (self parse: '"value"' rule: #tagValue) equals: 'value'.
	self assert: (self parse: '{value}' rule: #tagValue) equals: 'value'.
	self assert: (self parse: '2005' rule: #tagValue) equals: '2005'.
	self fail: ' "value" ' rule: #tagValue.
	self fail: ' {value} ' rule: #tagValue.
	self fail: ' 2005 ' rule: #tagValue
]

{ #category : #testing }
PPBibtexParserTest >> testTags [
	| tags |
	tags := 'tag="2005",tag="2005"'.
	self assert: (self parse: tags rule: #tags) size equals: 2.
	tags := ' tag="2005" , tag="2005" '.
	self assert: (self parse: tags rule: #tags) size equals: 2.
	tags := ' tag="2005",\tag="2005"\' withCRs.
	self assert: (self parse: tags rule: #tags) size equals: 2
]
