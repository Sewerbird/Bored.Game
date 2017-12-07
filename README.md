# bored.game System Design 

The `bored.game` engine is designed to provide scaffolding for simple two-dimensional games that Love2D doesn't provide out-of-the-box. This document goes over the primary components included in `bored.game`.

## Gamestate 

Bored models games in terms of tabletop board games: there are a variety of tokens, pieces, dice, and tiles that represent game objects, and all these elements live at specific locations on the table. The player can move pieces between zones according to the rules of the game, and the pieces can update themselves with the passage of time or in response to certain events. Here is a glossary of terms:


- *Players* are the participants in the game, and can be human or machine. Each player takes turns issuing commands to the game according to set rules, causing changes in the game state until a win or loss condition is met.  
- The *Scene* is analogous to the tabletop, and serves as the surface the game is played upon. All game objects are positioned in the scene.  
- *Zones* are designated sections of the Scene, and take up space. This includes things like your hand-of-cards, your token pile, the board area, and so on.  
- *Tiles* are placed in zones according to a fixed positioning scheme, such as in a grid, and tend to be semantic locations in the game where Pieces can land.  
- *Pieces* are placed in zones, and can be moved by the player in accordance with game rules. They tend to be placed on Tiles and bought with Tokens.  
- *Rules* constrain motion, creation, and removal of pieces and tokens in the game.  

## Components 

Zones, Tiles and Pieces share much of the same components, differing primarily in what they are used for. Otherwise, they all have a position, extent, shape, potential to have subordinated game elements, owners, and so on. They thus all use a common set of components as needed:


- The *Splat* component compartmentalizes the graphical aspect of each game element, being a background image, sprite, animation, particle system, or any other kind of visual effect. Splats can be nested in each other, but all are associated with their parent game element.  
- The *Shape* component defines a silhouette of the piece, and is very useful for setting up things like hitboxes, colliders, and click events. Often the Splat of a game element modifies the Shape, but this isn't required.  
- The *Stead* component encompasses all information needed to locate the game element spatialy in each major context. This means it provides the Cartesian, Board, and Screen coordinates on demand, converts between them, and can be updated to effect motion in a manner consistent in all coordinate systems.
- The *State* component represents the logical situation of a game element, allowing it to respond contextually to events in the game. Game elements can change their current state in response to transition events.
