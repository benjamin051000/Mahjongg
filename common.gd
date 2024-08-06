extends Node

# Order is important here, because these are used as integers 
# when determining sprite texture.
enum Suit {
	CRAK,
	BOO,
	DOT,
	HONOR
}

# TODO explain what each orientation means (e.g., "Left" means the top of the tile faces left,
# as if the player seated to your right was holding it.)
enum TilePerspective {
	BOTTOM, # First because it's most common, but I doubt it makes any real difference
	RIGHT, 
	TOP,
	LEFT,
}

# Number of tiles in a wall.
const wall_length := 19
