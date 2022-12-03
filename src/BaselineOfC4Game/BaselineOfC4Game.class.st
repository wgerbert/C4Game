"
I am an empty Base Line 
"
Class {
	#name : #BaselineOfC4Game,
	#superclass : #BaselineOf,
	#category : #BaselineOfC4Game
}

{ #category : #baselines }
BaselineOfC4Game >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'GtC4Game'. spec group: 'default' with: #('GtC4Game')]
]
