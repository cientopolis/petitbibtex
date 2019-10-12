Class {
	#name : #DoiToBibAPITest,
	#superclass : #TestCase,
	#category : #'DOI-tests'
}

{ #category : #testing }
DoiToBibAPITest >> testGet [
	| entry expectedEntry |
	entry := DoiToBibAPI new get: '10.1038/nphys1170'.
	expectedEntry := (PPBibtexParser new end
		parse:
			'@article{Aspelmeyer_2009,
  doi = {10.1038/nphys1170},
  url = {https://doi.org/10.1038%2Fnphys1170},
  year = {2009},
  month = jan,
  publisher = {Springer Science and Business Media {LLC}},
  volume = {5},
  number = {1},
  pages = {11--12},
  author = {Markus Aspelmeyer},
  title = {Measured measurement},
  journal = {Nature Physics}
}') first.
	self assert: entry equals: expectedEntry
]
