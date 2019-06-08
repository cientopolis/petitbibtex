Class {
	#name : #PPBibtexParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'tag',
		'tagName',
		'tagValue',
		'whitespace',
		'nonSeparator',
		'nonBraket',
		'nonQuote'
	],
	#category : #'PetitBibtex-parser'
}

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
PPBibtexParser >> start [
	"Answer the production to start this parser with."

	^ self tagValue end
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
	| curlied quoted number |
	curlied := (${ asParser , nonBraket plus flatten , $} asParser)
		==> [ :nodes | nodes second ].
	quoted := ($" asParser , nonQuote plus flatten , $" asParser)
		==> [ :nodes | nodes second ].
	number := #digit asParser plus flatten.
	^ curlied / quoted / number
]

{ #category : #productions }
PPBibtexParser >> tags [
	^ (tagName , whitespace star , $= asParser , whitespace star
		, tagValue)
		==>
			[ :nodes | BibtexTag name: nodes first value value: nodes fifth value ]
]

{ #category : #productions }
PPBibtexParser >> whitespace [
	^ PPPredicateObjectParser
		anyOf: (Array with: Character space with: Character tab)
]
