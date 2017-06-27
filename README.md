# scenemap
A plugin for Godot that enables using scenes in a tile map that mimmics the functionality of the native `TileMap`

## WIP
This plugin is still a work in progress and is in no way, shape or form ready for practical use. It is full of bugs,
messy and unoptimized code, performance issues, glitchy or missing features, etc.

## Features
* Support for non-sprite nodes as tiles
* Square and isometric perspectives
* Custom grid size
* Top-left, bottom-left and center tile origin
* Y-sorting

## How to use
Creating and preparing a tile set for a `SceneMap` is very similar to creating a til eset for a `TileMap`:

1. Create a new scene
2. Create a base node
3. Add any kind of nodes to the base node - all direct children to the root node will be used as tiles
4. Name these nodes appropriately - these names will also be used as the names of the tiles
5. Save the scene
6. Create a new `SceneMap` node anywhere in the scene it is to be used
7. Load the scene via the `Scene Set` property
8. Tiles can now be placed and removed in a similar fashion to `TileMap`s using the same familiar interface
