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
PPBibtexParserTest >> testEntries [
	| entries string |
	entries := {(BibtexEntry
		type: 'type'
		citationKey: 'pitts123'
		tags:
			{(BibtexTag name: 'tag' value: '2005').
			(BibtexTag name: 'tag' value: '2005')}).
	(BibtexEntry
		type: 'type'
		citationKey: 'pitts123'
		tags:
			{(BibtexTag name: 'tag' value: '2006').
			(BibtexTag name: 'tag' value: '2006')})}.
	string := ' @type { pitts123,
    tag = {2005},

    tag = {2005},
   }
   @type { pitts123, tag = {2006}, tag = {2006}, }'.
	self assert: (self parse: string rule: #entries) equals: entries.
	string := '@type{pitts123,tag={2005},tag={2005},}@type{pitts123,tag={2006},tag={2006},}'.
	self assert: (self parse: string rule: #entries) equals: entries
]

{ #category : #testing }
PPBibtexParserTest >> testEntry [
	| entry entryString |
	entry := BibtexEntry
		type: 'type'
		citationKey: 'pitts123'
		tags:
			{(BibtexTag name: 'tag' value: '2005').
			(BibtexTag name: 'tag' value: '2005')}.
	entryString := ' @type { pitts123,
    tag = {2005},

    tag = {2005},
   }'.
	self assert: (self parse: entryString rule: #entry) equals: entry.
	entryString := '@type{pitts123,tag={2005},tag={2005},}'.
	self assert: (self parse: entryString rule: #entry) equals: entry.
	entryString := '@TYPE{pitts123,tag={2005},tag={2005},}'.
	self assert: (self parse: entryString rule: #entry) equals: entry.
	entryString := '@type{pitts123,' , Character lf asString
		, 'tag={2005},tag={2005},}'.
	self assert: (self parse: entryString rule: #entry) equals: entry.
	entryString := '@type{,tag={2005},tag={2005},}'.
	self
		assert: (self parse: entryString rule: #entry) citationKey
		equals: ''
]

{ #category : #testing }
PPBibtexParserTest >> testStringWithBalancedCurlies [
	self
		assert: (self parse: '{name}' rule: #stringWithBalancedCurlies)
		equals: '{name}'.
	self
		assert: (self parse: '{n\{am\}e}' rule: #stringWithBalancedCurlies)
		equals: '{n\{am\}e}'.
	self
		assert: (self parse: '{{name}}' rule: #stringWithBalancedCurlies)
		equals: '{{name}}'.
	self
		assert: (self parse: '{ ad {name} d }' rule: #stringWithBalancedCurlies)
		equals: '{ ad {name} d }'.
	self
		assert: (self parse: '{}' rule: #stringWithBalancedCurlies)
		equals: '{}'.
	self fail: '  name  ' rule: #tagName.
	self fail: '  { ' rule: #tagName
]

{ #category : #testing }
PPBibtexParserTest >> testTag [
	| tag |
	tag := BibtexTag name: 'tag' value: '2005'.
	self assert: (self parse: 'tag="2005"' rule: #tag) equals: tag.
	self assert: (self parse: 'tag={2005}' rule: #tag) equals: tag.
	self assert: (self parse: 'tag=2005' rule: #tag) equals: tag.
	self assert: (self parse: '  tag  =  "2005"  ' rule: #tag) equals: tag.
	self assert: (self parse: '  tag  =  {2005}  ' rule: #tag) equals: tag.
	self assert: (self parse: '  tag =  2005  ' rule: #tag) equals: tag
]

{ #category : #testing }
PPBibtexParserTest >> testTagName [
	self assert: (self parse: 'name' rule: #tagName) equals: 'name'.
	self fail: '  name  ' rule: #tagName
]

{ #category : #testing }
PPBibtexParserTest >> testTagValue [
	self assert: (self parse: '"value"' rule: #tagValue) equals: 'value'.
	self assert: (self parse: '{value}' rule: #tagValue) equals: 'value'.
	self assert: (self parse: '2005' rule: #tagValue) equals: '2005'.
	"The next one does not comply with the standard syntax, but is present in the test file provided by the bibtex-test CTAN package"
	self assert: (self parse: 'value' rule: #tagValue) equals: 'value'.
	self
		assert: (self parse: '{{value}}' rule: #tagValue)
		equals: '{value}'.
	self
		assert: (self parse: '{weird {value} case}' rule: #tagValue)
		equals: 'weird {value} case'.
	self
		assert: (self parse: '{weird {value} case}' rule: #tagValue)
		equals: 'weird {value} case'.
	self
		assert: (self parse: '{}' rule: #tagValue)
		equals: ''.
	self fail: ' "value" ' rule: #tagValue.
	self fail: '  {value}  ' rule: #tagValue.
	self fail: ' 2005 ' rule: #tagValue
]

{ #category : #testing }
PPBibtexParserTest >> testTags [
	| tags tagsString |
	tags := {(BibtexTag name: 'tag' value: '2005').
	(BibtexTag name: 'tag' value: '2005')}.
	tagsString := 'tag="2005",tag="2005",'.
	self
		assertCollection: (self parse: tagsString rule: #tags)
		equals: tags.
	tagsString := ' tag="2005"  ,  tag="2005", '.
	self
		assertCollection: (self parse: tagsString rule: #tags)
		equals: tags.
	tagsString := 'tag="2005",\tag="2005",\' withCRs.
	self
		assertCollection: (self parse: tagsString rule: #tags)
		equals: tags.
	tagsString := 'tag="2005",tag="2005"'.
	self
		assertCollection: (self parse: tagsString rule: #tags)
		equals: tags
]
