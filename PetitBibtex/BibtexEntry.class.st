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
BibtexEntry class >> empty: type [
	^ self new
		  type: type
		  citationKey: Time now asMilliSeconds printString
		  withEmptyTagsNamed: (self standardFieldsFor: type);
		  yourself
]

{ #category : #'instance creation' }
BibtexEntry class >> emptyArticle [

	^ self new
		  type: 'article'
		  citationKey: Time now asMilliSeconds printString
		  withEmptyTagsNamed: (self standardFieldsFor: 'article');
		  yourself
]

{ #category : #'instance creation' }
BibtexEntry class >> emptyBook [

	^ self empty: 'book'
]

{ #category : #'instance creation' }
BibtexEntry class >> emptyInbook [

	^ self empty: 'inbook'
]

{ #category : #'instance creation' }
BibtexEntry class >> emptyInproceedings [

	^ self empty: 'inproceedings'
]

{ #category : #'instance creation' }
BibtexEntry class >> emptyMastersthesis [

	^ self empty: 'mastersthesis'
]

{ #category : #'instance creation' }
BibtexEntry class >> emptyMisc [

	^ self empty: 'misc'
]

{ #category : #'instance creation' }
BibtexEntry class >> emptyPhdthesis [

	^ self empty: 'phdthesis'
]

{ #category : #'instance creation' }
BibtexEntry class >> emptyTechreport [

	^ self empty: 'techreport'
]

{ #category : #constants }
BibtexEntry class >> standardFields [

	^ Dictionary new
		  at: 'article'
		  put:
			  { 'author'. 'title'. 'journal'. 'year'. 'volume'. 'number'.
			  'pages'. 'month'. 'note' };
		  at: 'inproceedings'
		  put:
			  { 'author'. 'title'. 'booktitle'. 'year'. 'editor'. 'pages'.
			  'organization'. 'publisher'. 'address'. 'month'. 'note' };
		  at: 'inbook'
		  put:
			  { 'author'. 'editor'. 'title'. 'chapter'. 'pages'. 'publisher'.
			  'year'. 'volume'. 'series'. 'address'. 'edition'. 'month'. 'note'.
			  'key' };
		  at: 'book'
		  put:
			  { 'author'. 'editor'. 'title'. 'publisher'. 'year'. 'volume'.
			  'series'. 'address'. 'edition'. 'month'. 'note' };
		  at: 'techreport'
		  put:
			  { 'author'. 'title'. 'institution'. 'year'. 'number'. 'address'.
			  'month'. 'type'. 'note' };
		  at: 'mastersthesis'
		  put:
			  { 'author'. 'title'. 'school'. 'year'. 'type'. 'address'.
			  'month'. 'note' };
		  at: 'phdthesis'
		  put:
			  { 'author'. 'title'. 'school'. 'year'. 'type'. 'address'.
			  'month'. 'note' };
		  at: 'misc'
		  put:
			  { 'author'. 'title'. 'howpublished'. 'year'. 'month'. 'note' };
		  yourself
]

{ #category : #constants }
BibtexEntry class >> standardFieldsFor: aType [

	^ self standardFields at: aType
]

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

{ #category : #initialization }
BibtexEntry >> type: aTypeString citationKey: aKeyString withEmptyTagsNamed: aCollectionOfTagNames [

	type := aTypeString.
	citationKey := aKeyString.
	aCollectionOfTagNames do: [ :each | self at: each put: '' ]
]

{ #category : #'utility-accessors' }
BibtexEntry >> year [
	^ self at: 'year'
]
