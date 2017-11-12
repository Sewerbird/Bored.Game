# bored.game System Design

The `bored.game` engine is designed to provide scaffolding for simple
two-dimensional games that Love2D doesn't provide out-of-the-box. This document
goes over the primary components included in `bored.game`.

## Gamestate

Bored models games in terms of tabletop board games: there are a variety of
tokens, pieces, dice, and tiles that represent game objects, and all these elements
live at specific locations on the table. The player can move pieces between
zones according to the rules of the game, and the pieces can update themselves
with the passage of time or in response to certain events. Here is a glossary of
terms:

- The *Scene* is analogous to the tabletop, and serves as the surface the game
  is played upon. All game objects are positioned in the scene.
- *Zones* are designated sections of the Scene, and take up space. This includes
  things like your hand-of-cards, your token pile, the board area, and so on.
- *Tiles* are placed in zones according to a fixed positioning scheme, such as
  in a grid, and tend to be semantic locations in the game where Pieces can
  land.
- *Pieces* are placed in zones, and can be moved by the player in accordance
  with game rules. They tend to be placed on Tiles and bought with Tokens.
- *Tokens* are similar to pieces, but serve as numeric counters or currency.
  They tend not to be moved directly by the player.:w
- *Players* are the participants in the game, and can be human or machine. 
- *Rules* constrain motion, creation, and removal of pieces and tokens in the
  game.


