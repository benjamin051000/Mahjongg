extends Node

# Order is important here, because these are used as integers 
# when determining sprite texture.
enum Suit {
	CRAK,
	BOO,
	DOT,
	HONOR
}

enum TilePerspective {
	BOTTOM, # First because it's most common, but I doubt it makes any real difference
	RIGHT,
	TOP,
	LEFT,
}
