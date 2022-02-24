## Inspiration

I was inspired to create pretty visuals and learn more about animations in Flutter.

I also wanted to challenge myself and perhaps create something i could showcase for future employers.

Winning a price would not be too shabby, either ;)

## What it does

It has the basic sliding puzzle logic, but I've also added a new layer of simulated particles and added sounds to each tile.

Neatly packaged using a minimal design approach.

## How we built it

I first tried to build on the original puzzle hack code, but i felt the architecture was a bit constraining and i had to redo a lot anyway so i started again from a new project.

First i made a very simple sliding puzzle game to get started. The logic was pretty easy to get right and i used a `ValueNotifer` to hold the puzzle state (similar to what I've described in my Medium article [Pragmatic State Handling in Flutter](https://medium.com/@erlendf/pragmatic-state-handling-in-flutter-d8c9bf5d7d2)).

I knew from the start i wanted to simulate particles, and i imagined the particles were able to move around freely behind the grid of buttons. So i added two grids in a `Stack` - one with the buttons that the users could press to move the tiles, and another layer with simulated particles that got its position from the buttons using `GlobalKey`s.

I previously build the package [flim](https://github.com/erf/flim) for simulating sprites, so i knew i had to use a `StatefulWidget` with the `SingleTickerProviderStateMixin` in addition to a `CustomPainter`, if i wanted to simulate some particles effectively and with full freedom. I used two physics models, one for the attraction towards buttons, and one for the gravity in solved state. I initially had a more plans to use particles, but i think the minimal approach worked out OK.

I'm fan a minimal design approach, like in my other [apps](https://apptakk.com), so i ended up with a simple grid of squares and some circular particles inside. I love pastel colors and the pink particles, represented a fresh contrast with the grey squares.

I used to produce beats before, and i noticed the 4x4 grid is similar arranged as the Akai MPC series of samplers, so i thought it would be fun to add a sound to each square. I used my M8 tracker to find a nice synth sound. Played at different notes based on the tile value. It's sounding a bit eerie when played in random, as i shuffled the tiles at the start of each new game.

After playing around with these ideas, i kind of felt as the puzzle was telling a story. The story of some colorful particles trapped inside grey squares and which was trying to escape. Perhaps parallels can be drawn as to how we sometimes feel stuck in life.

## Challenges we ran into

There were some issues with drawing large points on iOS, so i made a github [issue](https://github.com/flutter/flutter/issues/98880). I however solved it using `canvas.drawCircle` instead.

There was a bit challenging to get the state changes of the puzzle to update the particle positions, without creating too many state changes and rebuilds. I do however think i found a solution that works. Perhaps this could be revisited.

There were some issues with supporting all kinds of screens, but i think the current solution works. We use a max grid size and scale it down on lower screens, updating the particle positions as well.

## Accomplishments that we're proud of

I feel the overall theme came out pretty nice in the end. I like the simulated particles roaming around, following the buttons as they move.

I also feel the sounds added something new to the puzzle game.

## What we learned

Adding sounds to Flutter is something i have not done before, and this was a fun experience. Sound is working on all platforms using [soundpool](https://pub.dev/packages/soundpool).

I also learned more about animations as i had to read up on the [documentation](https://docs.flutter.dev/development/ui/animations/tutorial).

I also enjoyed revisiting graphics and simulation programming. I have a master in 3d programming but i have not been able to use it much lately, so it's fun to get into more graphics programming!

## What's next for Let Me Out !

Not quite sure, but i would love to play around more with particle simulations. There are lots of various visuals and physics i could add to the game to make it more interactive, on top of the basic sliding puzzle premise.

Thanks for arranging this fun programming competition !

<3
