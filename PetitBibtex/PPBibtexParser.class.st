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
		'stringWithBalancedCurlies'
	],
	#category : #'PetitBibtex-parser'
}

{ #category : #productions }
PPBibtexParser >> entries [
	^ (whitespace star , entry star , whitespace star)
		==> [ :nodes | nodes second ]
]

{ #category : #productions }
PPBibtexParser >> entry [
	^ (whitespace star flatten , $@ asParser , nonBraket plus flatten
		, ${ asParser , whitespace star flatten , nonSeparator plus flatten
		, $, asParser , tags , $} asParser , whitespace star)
		==> [ :nodes | 
			BibtexEntry
				type: nodes third trim
				citationKey: nodes sixth trim
				tags: nodes eighth ]
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
PPBibtexParser >> start [
	"Answer the production to start this parser with."

	^ self entries end
]

{ #category : #productions }
PPBibtexParser >> stringWithBalancedCurlies [
	^ (${ asParser , (nonBraket / stringWithBalancedCurlies) plus 
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
	| curlied quoted number |
	curlied := stringWithBalancedCurlies
		==> [ :nodes | nodes copyFrom: 2 to: nodes size - 1 ].
	quoted := ($" asParser , nonQuote plus flatten , $" asParser)
		==> [ :nodes | nodes second ].
	number := #digit asParser plus flatten.
	^ curlied  / quoted / number
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
