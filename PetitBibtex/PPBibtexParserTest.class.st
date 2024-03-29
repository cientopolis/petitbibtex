Class {
	#name : #PPBibtexParserTest,
	#superclass : #PPCompositeParserTest,
	#instVars : [
		'entries'
	],
	#category : #'PetitBibtex-tests'
}

{ #category : #accessing }
PPBibtexParserTest >> parserClass [
	^ PPBibtexParser 
]

{ #category : #testing }
PPBibtexParserTest >> setUp [

	super setUp.

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
					            (BibtexTag name: 'tag' value: '2006') }) }
]

{ #category : #testing }
PPBibtexParserTest >> testEntries [

	| string |
	string := ' @type { pitts123,
    tag = {2005},

    tag = {2005},
   }
   @type { pitts123, tag = {2006}, tag = {2006}, }'.
	self assert: (self parse: string rule: #entries) equals: entries.
	string := '@type{pitts123,tag={2005},tag={2005},}@type{pitts123,tag={2006},tag={2006},}'.
	self assert: (self parse: string rule: #entries) equals: entries.
	self assert: (self parse: string) equals: entries.
]

{ #category : #testing }
PPBibtexParserTest >> testEntry [

	| entry entryString |
	entry := entries first.
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
		equals: ''.
		
	"Accept spaces in the citation key as incorrecly used by Scopus"	
	entryString := '@type{pitts 123,tag={2005},tag={2005},}'.
	self
		assert: (self parse: entryString rule: #entry) citationKey
		equals: 'pitts 123'
]

{ #category : #testing }
PPBibtexParserTest >> testIgnorableText [

	| string |
	string := 'this text should be ignored', 
	entries first printString.
	self assert: (self parse: string rule: #entries) first equals: entries first
]

{ #category : #testing }
PPBibtexParserTest >> testMissingLfCrTabSpaceOrAtEndOfEntry [
  "This was reported as issue #1 on github"
	| string   entries |
	string := '@inproceedings{9270294,
	}'.
	parser := PPBibtexParser new.
	entries := PPBibtexParser new parse: string.
	self assert: entries isPetitFailure not

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
