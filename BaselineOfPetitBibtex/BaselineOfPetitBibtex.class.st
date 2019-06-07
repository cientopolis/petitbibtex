Class {
	#name : #BaselineOfPetitBibtex,
	#superclass : #BaselineOf,
	#category : #BaselineOfPetitBibtex
}

{ #category : #baseline }
BaselineOfPetitBibtex >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'PetitParser'
				with: [ spec repository: 'github://moosetechnology/PetitParser/src' ].
			spec package: 'PetitBibtex' with: [ spec requires: 'PetitParser' ] ]
]
