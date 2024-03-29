"
A LO4Game is a 4 in a row Game

Instance Variables
	cells:		<Object>
	choices:		<Object>

cells
	- xxxxx

choices
	- xxxxx

"
Class {
	#name : #C4Game,
	#superclass : #BorderedMorph,
	#instVars : [
		'cells',
		'player',
		'board',
		'playerVal',
		'winRevenue',
		'loseRevenue',
		'uncertainRevenue',
		'maxDepth'
	],
	#category : #C4Game
}

{ #category : #GameLogic }
C4Game >> alphabetaDepth:depth alpha:alpha beta:beta maximizePlayer:maxp [
"Alphabeta"
| win a b|
win:=self getWinner.
win=1 ifTrue:[^(loseRevenue / (maxDepth - depth +1)) ]."Player will win"
win=playerVal ifTrue:[^(winRevenue / (maxDepth - depth +1)) ]  ."AI will win"
depth=0 ifTrue:[^uncertainRevenue ]."No idea"
a:=alpha .b:=beta.
maxp  ifTrue:[ (1 to: 7 do:[:col| (self simulateMove: col player:2)  
		ifTrue: [ a:= self alphabetaDepth:(depth-1)  alpha:a  beta:b  maximizePlayer:false.
				a := alpha max:a.
				self undoMove: col.
				a>=beta ifTrue:[^a] .
			  ].
		]).
	^a]
ifFalse:[(1 to: 7 do:[:col| (self simulateMove: col player:1) 
		ifTrue: [ b:=self alphabetaDepth:(depth-1)  alpha:a beta:b  maximizePlayer:true.
				b := beta min:b.
				self undoMove: col.
				alpha>=b ifTrue:[^b] .
			  ].
		]).
	^b].

]

{ #category : #accessing }
C4Game >> board [
	
	^ board
]

{ #category : #accessing }
C4Game >> board: anObject [
	
	board := anObject
]

{ #category : #accessing }
C4Game >> cells [
	
	^ cells
]

{ #category : #accessing }
C4Game >> cells: anObject [
	
	cells := anObject
]

{ #category : #GameLogic }
C4Game >> dropChipAt: col State: state Val: val [
	"drops a chip in the board"

	| row cell win |
	row := 1.
	cell := cells at: row at: col.
	[ cell state = Color paleYellow or: row > 5 ]
		whileFalse: [ row := row + 1.
			cell := cells at: row at: col ].
	cell state = Color paleYellow
		ifTrue: [ cell color: state.
			cell state: state.
			board at: row at: col put: val.
			win := self getWinner.
			win = 2
				ifTrue: [ self owner setLabel:'I win!'.cells do:[:c|c state = Color paleYellow ifTrue:[c state:Color purple .c color:Color cyan ]] ].	"I win"
			win = 1
				ifTrue: [ self owner setLabel: 'You win!'.
					cells
						do: [ :c | 
							c state = Color paleYellow
								ifTrue: [ c state: Color green.
									c color: Color green ] ].
					^ false ].	"You win!'"
			^ true ].
	^ false
]

{ #category : #GameLogic }
C4Game >> getWinner [
"Returns winner if found"
|winner val|
winner:=0.
(1 to: 7 do:[:col| 1 to:6 do:[ :row|val:=self searchChainAt:col at: row. (val>winner) ifTrue:[^val]]]).
^winner
]

{ #category : #initialization }
C4Game >> initialize [
	| sampleCell width height rows cols |
	super initialize.
	player := Color red.
	playerVal := 1.
	rows := 6.
	cols := 7.
	winRevenue := 1.
	loseRevenue := -1.
	uncertainRevenue := 0.
	maxDepth := 8.
	sampleCell := C4Cell new.
	width := sampleCell width.
	height := sampleCell height.
	self
		bounds:
			(5 @ 5
				extent: (width * cols) @ (height * rows) + (2 * self borderWidth)).
	cells := Array2D
		rows: rows
		columns: cols
		tabulate: [ :i :j | self newCellAt: i at: j ].
	board := Array2D rows: rows columns: cols tabulate: [ :i :j | 0 ].	"element:0."
	self openInWindowLabeled: 'Connect Four'
]

{ #category : #GameLogic }
C4Game >> isValidMove:col [
"is the last row still empty?"
 |row val|

row:=6.
val:=board at:row at:col.
^(0=val).

]

{ #category : #accessing }
C4Game >> loseRevenue [
	
	^ loseRevenue
]

{ #category : #accessing }
C4Game >> loseRevenue: anObject [
	
	loseRevenue := anObject
]

{ #category : #GameLogic }
C4Game >> makeTurnAI [
"AI Turn"
	|maxVal move sum|

	maxVal:=-222.sum:=0.
	move:=0.
 	[:break|1 to: 7 do: [:i| (self isValidMove: i) 
		ifTrue:[|val| val:=self moveValueAt:i. sum:=sum+val.
				(val=1) | (val= -1) ifTrue:[move:=i.break value].
				(val >maxVal) ifTrue:[ maxVal:=val . move:=i.].
				].
			].
	] valueWithExit .
	sum=0 ifTrue:[move:=(5 atRandom +1)].
	self dropChipAt: move State:Color blue  Val: 2. 
      ^move

]

{ #category : #accessing }
C4Game >> maxDepth [
	
	^ maxDepth
]

{ #category : #accessing }
C4Game >> maxDepth: anObject [
	
	maxDepth := anObject
]

{ #category : #GameLogic }
C4Game >> moveValueAt: col [
	"Get value of the move"

	| val win |
	"Did AI already win?"
	win := self getWinner.
	win = 2
		ifTrue: [ ^ 1 ].
	"Check if oponent wins in the next move"
	self simulateMove: col player: 1.
	win := self getWinner.
	self undoMove: col.
	win = 1
		ifTrue: [ ^ -1 ].
	"Start own try"
	self simulateMove: col player: 2.
	val := self
		alphabetaDepth: maxDepth 
		alpha: -111
		beta: 111
		maximizePlayer: false.
	self undoMove: col.
	^ val
]

{ #category : #GameLogic }
C4Game >> newCellAt: row at: col [
	"create a new cell at (i,j) "

	| c origin |
	c := C4Cell new.
	origin := self innerBounds origin.
	self addMorph: c.
	c position: ((col - 1) * c width) @ ((6 - row) * c height) + origin.
	c mouseAction: [ (self dropChipAt: col State: self player Val: playerVal)
				ifTrue: [ self switch ] ].
	^ c
]

{ #category : #accessing }
C4Game >> player [
	
	^ player
]

{ #category : #accessing }
C4Game >> player: anObject [
	
	player := anObject
]

{ #category : #accessing }
C4Game >> playerVal [
	
	^ playerVal
]

{ #category : #accessing }
C4Game >> playerVal: anObject [
	
	playerVal := anObject
]

{ #category : #GameLogic }
C4Game >> searchChainAt:col at: row [
|val|
val:=board at:row at:col.
val=0 ifTrue:[^0]."No val to begin with"

"search Up"
	(row<4) ifTrue:[(self searchNext:val col:col row:row x:0 y:1 count:1) >3 ifTrue:[.^val]].
"Search diagonal right up"
	(row<4 and: col<5) ifTrue:[(self searchNext:val col:col row:row x:1 y:1 count:1) >3 ifTrue:[^val]].
"Search right"	
	(col<5) ifTrue:[(self searchNext:val col:col row:row x:1 y:0 count:1) >3 ifTrue:[^val]].
"Search diagonal right down"	
	(row>3 and: col<5) ifTrue:[(self searchNext:val col:col row:row x:1 y:(-1) count:1) >3 ifTrue:[^val]].
	^0.
]

{ #category : #GameLogic }
C4Game >> searchNext:val col:col row:row x:x y:y count:cnt [
"searches the next chip in the given direction" 
|b u v ret|
u:=col+x.
v:=row+y.
ret:=cnt.
b:=board at:v at:u ifInvalid:0. 
(b=val) ifTrue:[ret:=self searchNext:val col:u row:v x:x y:y count:(cnt+1)].
^ret.
]

{ #category : #GameLogic }
C4Game >> simulateMove:col player:playval [
"simulate AI"
 |row |

row:=1.

[(board at:row at:col)=0 or: row>5]
	whileFalse: [ row:=row+1].

(board at:row at:col)=0 ifTrue: [board at:row at:col put:playval.^true ].
^false.
]

{ #category : #GameLogic }
C4Game >> switch [
"switch player"
(player=Color red) ifTrue: [ player:=Color blue.playerVal:=2.self makeTurnAI.self switch ]
					ifFalse:[player :=Color red.playerVal:=1 ].
]

{ #category : #accessing }
C4Game >> uncertainRevenue [
	
	^ uncertainRevenue
]

{ #category : #accessing }
C4Game >> uncertainRevenue: anObject [
	
	uncertainRevenue := anObject
]

{ #category : #GameLogic }
C4Game >> undoMove:col [
" undo the last move"
 |row |

row:=6.

[(board at:row at:col)=0 and: (row>1)]
	whileTrue: [ row:=row-1].
	
(board at:row at:col)=0 ifFalse: [board at:row at:col put:0.^true ].
^false.	
]

{ #category : #accessing }
C4Game >> winRevenue [
	
	^ winRevenue
]

{ #category : #accessing }
C4Game >> winRevenue: anObject [
	
	winRevenue := anObject
]
