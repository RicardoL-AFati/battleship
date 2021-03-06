module Prompts
  WELCOME = '''
                                Welcome to
██████╗  █████╗ ████████╗████████╗██╗     ███████╗███████╗██╗  ██╗██╗██████╗ 
██╔══██╗██╔══██╗╚══██╔══╝╚══██╔══╝██║     ██╔════╝██╔════╝██║  ██║██║██╔══██╗
██████╔╝███████║   ██║      ██║   ██║     █████╗  ███████╗███████║██║██████╔╝
██╔══██╗██╔══██║   ██║      ██║   ██║     ██╔══╝  ╚════██║██╔══██║██║██╔═══╝ 
██████╔╝██║  ██║   ██║      ██║   ███████╗███████╗███████║██║  ██║██║██║     
╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝     
'''
  START = "Would you like to (p)lay, read the (i)nstructions, or (q)uit?\n"
  INSTRUCTIONS =
  """
  The basic Battleship rules and instructions for playing the game
  are each player calls out one shot (or coordinate) each turn in an
  attempt to hit one of their opponent’s ships. To “hit” one of your
  opponent’s ships, you must input a letter and a number of where you
  think one of their ships is located. Once a shot is called, the
  opponent calls out “hit” or “miss.” If one of your ships gets hit,
  an H will appear on your ship. If shooting at the enemy an H mark
  will be displayed (if a hit was made) or an M (a miss) on your target
  grid located. This will help you keep track of your hits and misses
  in your hunt to find their ships.

  Once all coordinates of a ship have been filled with H, the ship has
  sunk and must be removed from the ocean. You then announce which ship
  has sunk. The Battleship rules on successfully sinking a ship are as
  follows:  Cruiser – 3 hits, Destroyer – 2 hits.

  Proper coordinate input:

  A3 A4

  - LETTERS A-D
  - NUMBERS 1-4
  - MUST BE CONSECUTIVE ON THE GRID
  - MUST NOT OVERLAP PREVIOUS SHIP PLACEMENT
  """

  INVALID_CHOICE = "Enter one of the letters in () or the entire word - no spaces"
  GET_PLAYER_COORDINATE = "Enter the squares for a %s-unit ship"
  PLAYER_SHOTS = "============\nPLAYER SHOTS\n"
  PLAYER_BOARD = "============\nPLAYER BOARD\n"
  TOP = "============\n. 1 2 3 4\n"
  BOTTOM = "============\n"
  EMPTY_BOARD = "A          \nB          \nC          \nD          \n"
  BOAT_HIT = "Boat Hit on %s! \u{1F4A5}\u{1F4A5}\u{1F4A5}"
  BOAT_MISS = "Boat Miss on %s! \u{1F4A6}\u{1F4A6}\u{1F4A6}"
  SUNK_BOAT = "A Boat of length %s was just sunk"
  PLAYER_TURN = "~~~~~~~~~~~~~~~~~~~\n  PLAYERS TURN   \n~~~~~~~~~~~~~~~~~~~\n"
  COMPUTER_TURN = "~~~~~~~~~~~~~~~~~~~\n  COMPUTERS TURN   \n~~~~~~~~~~~~~~~~~~~\n"
  WIN_SCREEN = "~~~~~~~~~~~~~~~~~~~\n  \u{1F929}!!YOU WON!!\u{1F929}  \n~~~~~~~~~~~~~~~~~~~\n"
  LOSE_SCREEN = "~~~~~~~~~~~~~~~~~~~\n  \u{1F62D}YOU LOST..\u{1F62D}  \n~~~~~~~~~~~~~~~~~~~\n"
  SHOT_COUNT = "============\nThe game was won in %s turns\n============\n"
  PRESS_ENTER = "Press ENTER to continue"
  TIME_TAKEN = "Total time taken for this game is %s"
  def self.print_empty_board
    print TOP
    print EMPTY_BOARD
    print BOTTOM
  end
end
