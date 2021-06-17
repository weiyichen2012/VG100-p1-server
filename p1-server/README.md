### Outline
- code on server side, used for online battling.
---
### Run
- you need "nodejs"
- enter "npm install uuid ws"
- run "node socketListen.js".
---
### Client actions:
- [X] `changeClient` 0
  - changeClient `name`
- [X] `refreshHall` 1
  - refreshHall
- [X] `createRoom`2
  - createRoom
- [X] `joinRoom`3
  - joinRoom `roomNum`
- [X] `refreshRoom` 4
  - refreshRoom
- [X] `changeRoom` 5
  - changeRoom `name`
- [X] quitRoom 6
  - `quitRoom`
- [X] `startRoomGame`7
  - startRoomGame
- [X] `hostSendGameStatus` 8
  - onlineBattle1: hostSendGameStatus `ball_x` `ball_y` `paddleUp_x` `paddleUp_dir` `paddleDown_x` `paddleDown_dir` `delayTime` `upScore` `downScore`
- [X] `clientSendControlStatus` 9
  - clientSendControlStatus `KeyUp|KeyDown` `keyCode`
- [X] `gameClose` 10
  - `gameClose` `reason: switchToRoom`
- [X] `ping` 11
  - `ping`
---
### Server actions:
- [X] `changeClientStatus` 0
  - changeClientStatus `uuid` `name`
- [X] `refreshHallStatus` 1
  - refreshHallStatus
    `n` `client1uuid` `client1name` `client1roomUUID` ...... `clientnuuid` `clientnname` `clientnroomUUID`
    `n` `room1uuid` `room1name` `room1playerNum` ...... `roomnuuid` `roomnname` `roomnplayerNum`
- [X] `joinRoomStatus` 2
  - calling refreshRoomStatus `force`
- [X] `refreshRoomStatus` 3
  - refreshRoomStatus `uuid` `name` `n` `client1uuid` `client1name` `client1roomUUID` ...... `clientnuuid` `clientnuuid` `clientnroomUUID`
- [X] `changeRoomStatus` 4
  - calling refreshRoomStatus
- [X] `quitRoomStatus` 5
  - calling `refreshHallStatus` `force`
- [X] `startRoomGameStatus` 6
  - `startRoomGameStatus` `Host|Client`
- [X] `hostGameStatusToClient` 7
  - onlineBattle1: hostGameStatusToClient `ball_x` `ball_y` `paddleUp_x` `paddleUp_dir` `paddleDown_x` `paddleDown_dir` `delayTime` `upScore` `downScore`
- [X] `clientControlStatusToHost` 8
  - clientControlStatusToHost `KeyUp|KeyDown` `keyCode`
- [X] `gameClose` 9
  - gameClose `reason: onePlayerDisconnect | switchToRoom`
- [X] `pong` 10
  - pong