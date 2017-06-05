# Replay by Play

Replays Sportradar Play by Plays as if the game was currently being played.

## Install

Run `bundle install` to install gems.

## Running

Run the following command:

```
PBP_URL=https://api.sportradar.us/ncaafb-t1/2016/REG/19/CLE/BAMA/pbp.json\?api_key\=<key> SPEED=2 bundle exec ruby app.rb
```

`PBP_URL` should be the url to the play by play you want to replay.
`SPEED` is how fast you want the replay to go. The default is `1`. Setting it to `2` will make it go twice as fast.

You will then need to update your apps to point to the running instance of this app.

## To Do

* Update the summary at the top based on what has happened. Currently it is the final stats.
* Test with multiple sports. Currently it has only been tested with NCAA Football.
