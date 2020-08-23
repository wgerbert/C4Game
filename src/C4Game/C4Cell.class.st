"
A LO4Cell is a Cell on the Board Game

Instance Variables
	mouseAction:		<Object>

mouseAction
	- xxxxx

"
Class {
	#name : #C4Cell,
	#superclass : #SimpleButtonMorph,
	#instVars : [
		'mouseAction',
		'state'
	],
	#category : #C4Game
}

{ #category : #'instance creation' }
C4Cell class >> mouseAction: mouseAction state: state [

	^ self new
		mouseAction: mouseAction;
		state: state;
		yourself
]

{ #category : #accessing }
C4Cell >> initialize [
	super initialize.
	self label: ''.
	self borderWidth: 2.
	bounds:= 0@0 corner: 40@40.
	color := Color paleYellow .
	self  useSquareCorners .
	state := Color paleYellow.
	
]

{ #category : #accessing }
C4Cell >> mouseAction [
	
	^ mouseAction
]

{ #category : #accessing }
C4Cell >> mouseAction: anObject [
	
	mouseAction := anObject
]

{ #category : #accessing }
C4Cell >> mouseUp: anEvent [
	mouseAction value.
]

{ #category : #accessing }
C4Cell >> state [
	
	^ state
]

{ #category : #accessing }
C4Cell >> state: anObject [
	
	state := anObject
]
