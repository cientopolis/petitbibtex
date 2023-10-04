Class {
	#name : #PPBibtexParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'entries',
		'entry',
		'tags',
		'tag',
		'tagName',
		'tagValue',
		'whitespace',
		'nonSeparator',
		'nonBraket',
		'nonQuote',
		'nonAt',
		'stringWithBalancedCurlies',
		'scapedBraket'
	],
	#category : #'PetitBibtex-parser'
}

{ #category : #accessing }
PPBibtexParser class >> startSymbol [

	^ #entries
]

{ #category : #productions }
PPBibtexParser >> entries [
	^ (nonAt star , entry star , nonAt star)
		==> [ :nodes | nodes second ]
]

{ #category : #productions }
PPBibtexParser >> entry [
	^ (whitespace star flatten , $@ asParser , nonBraket plus flatten
		, ${ asParser , whitespace star flatten , nonSeparator star flatten
		, $, asParser , tags , $} asParser , whitespace star)
		==> [ :nodes | 
			BibtexEntry
				type: nodes third trim asLowercase
				citationKey: nodes sixth trim
				tags: nodes eighth ]
]

{ #category : #productions }
PPBibtexParser >> nonAt [

	^ PPPredicateObjectParser anyExceptAnyOf: { $@ }
]

{ #category : #productions }
PPBibtexParser >> nonBraket [
	^ PPPredicateObjectParser anyExceptAnyOf: {${ . $}} 
]

{ #category : #productions }
PPBibtexParser >> nonQuote [
	^ PPPredicateObjectParser
		anyExceptAnyOf:
			{$"}
]

{ #category : #productions }
PPBibtexParser >> nonSeparator [
	^ PPPredicateObjectParser
		anyExceptAnyOf:
			{Character space.
			Character tab.
			Character cr.
			Character lf.
			$=.
			$,}
]

{ #category : #accessing }
PPBibtexParser >> parse: anObject [
	
	^ super parse: (self removeCommentLinesIn: anObject)
]

{ #category : #accessing }
PPBibtexParser >> removeCommentLinesIn: anObject [
	| commentedLine nonCommentedLine expression result |
	expression := PPExpressionParser new.
	commentedLine := ($% asParser plus
		,
			(PPPredicateObjectParser
				anyExceptAnyOf:
					{Character lf.
					Character cr}) star
		, (Character lf asParser / Character cr asParser) plus)
		==> [ :nodes | '' ].
	nonCommentedLine := (PPPredicateObjectParser
		anyExceptAnyOf:
			{Character lf.
			Character cr}) star
		, (Character lf asParser / Character cr asParser) plus.
	expression term: (commentedLine / nonCommentedLine flatten) star.
	result := String new writeStream.
	(expression parse: anObject) do: [ :line | result nextPutAll: line ].
	^ result contents
]

{ #category : #productions }
PPBibtexParser >> scapedBraket [
	^ '\{' asParser / '\}' asParser
]

{ #category : #accessing }
PPBibtexParser >> start [
	"Answer the production to start this parser with."

	^ self entries end
]

{ #category : #productions }
PPBibtexParser >> stringWithBalancedCurlies [
	^ '{}' asParser
		/
			(${ asParser
				, (scapedBraket / nonBraket / stringWithBalancedCurlies) plus
				, $} asParser) flatten
]

{ #category : #productions }
PPBibtexParser >> tag [
	^ (whitespace star , tagName , whitespace star , $= asParser
		, whitespace star , tagValue , whitespace star)
		==>
			[ :nodes | BibtexTag name: nodes second value value: nodes sixth value ]
]

{ #category : #productions }
PPBibtexParser >> tagName [
	^ nonSeparator star flatten
]

{ #category : #productions }
PPBibtexParser >> tagValue [
	| curlied quoted number singleString |
	curlied := stringWithBalancedCurlies
		==> [ :nodes | nodes copyFrom: 2 to: nodes size - 1 ].
	quoted := ($" asParser , nonQuote plus flatten , $" asParser)
		==> [ :nodes | nodes second ].
	number := #digit asParser plus flatten.
	singleString := #letter asParser plus flatten.
	^ curlied  / quoted / number / singleString
]

{ #category : #productions }
PPBibtexParser >> tags [
	| theTag |
	theTag := (whitespace star , tag , whitespace star
		, $, asParser optional , whitespace star)
		==> [ :nodes | nodes second ].
	^ theTag star
]

{ #category : #productions }
PPBibtexParser >> whitespace [
	^ PPPredicateObjectParser
		anyOf:
			(Array
				with: Character space
				with: Character tab
				with: Character cr
				with: Character lf)
]
