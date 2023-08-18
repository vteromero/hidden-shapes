# Cart data layout

* 0: User preferences / game state bitfield

   ```
    0   1   2   3   4           5
   +---+---+---+---+-----------+-----+
   |  cpal |  dfty | introseen | ... |
   +---+---+---+---+-----------+-----+
   ```

   - `cpal`: selected color palette (1:dark, 2:light)
   - `dfty`: difficulty level (1:normal, 2:hard)
   - `introseen`: flag to tell whether intro has been seen or not

* 1-20: Level scores for "Normal" difficulty. For each record, the 16 lower bits hold best "checks" score for the level whereas the 16 higher bits are used to store the best "time".

* 21-40: Level scores for "Hard" difficulty. Same format as before.
