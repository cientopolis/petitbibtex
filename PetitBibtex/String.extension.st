Extension { #name : #String }

{ #category : #'*PetitBibtex' }
String >> copyWithoutLatexAccentsAndBraces [
	| replacements newString |
	newString := self.
	replacements := OrderedCollection  new.
	replacements
		add: '{' -> '';
		add: '}' -> '';
		add: '\''a' -> 'á';
		add: '\''e' -> 'é';
		add: '\''i' -> 'í';
		add: '\''o' -> 'ó';
		add: '\''i' -> 'i';
		add: '\''u' -> 'ú';
		add: '\"o' -> 'ö';
		add: '\"u' -> 'ü'.
	replacements
		do:
			[ :ass | newString := newString copyReplaceAll: ass key with: ass value ].
	^ newString
]
