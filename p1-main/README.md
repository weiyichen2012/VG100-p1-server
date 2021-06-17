### Outline
- Finishing p1m1 requests
- This project uses SVG.
- Well commented codes in `src/`.
- Good structures of the code, see in detail in `doc/milestone2Structure`.
---
### Function
- To move the paddle, press "A" "D" or arrow keys. It will not exceed the boundary and pressing them at the same time is handled correctly.
- To rotate the paddle, press "W" "S" or arrow keys.
- When you are dead, press "R" to revive.
---
### Run
- Enter this directory `p1-main/`, Build with `elm make src/Main.elm --output elm.js` and open `main.html`.
  - The reason for this is I want to do websocket for online battle in milestone3 and websocket isn't available for elm 0.19, but very convenient for js. I may try to use port function in elm.
---
#### Additional comments
- the .eddx file in `doc/` directory is used with software called "亿图图示", I find it useful when drawing diagrams, this .eddx file is equivilent to the .pdf file under the same directory.
---
###The following is used for my own coding
- 