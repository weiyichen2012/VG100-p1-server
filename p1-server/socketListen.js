const { v4: uuidv4 } = require('uuid');

const debug = true;

let WebSocketServer = require("ws").Server,
    Clients = [];
// UUID Name RoomUUID WS

let Rooms = [];
// UUID Name [Clients {UUID Name RoomUUID}] ifStart

const wsServer = new WebSocketServer({port: 1234});

function findRoomByUUID (uuid) {
    let findRoom = undefined;
    for (let i = 0; i < Rooms.length; ++i) {
        if (Rooms[i] !== undefined && Rooms[i].uuid === uuid)
            findRoom = Rooms[i];
    }
    if (findRoom === undefined)
        console.log("Error in findRoomByUUID: couldn't find room");
    return findRoom;
}

function deleteRoomByUUID (uuid) {
    for (let i = 0; i < Rooms.length; ++i) {
        if (Rooms[i] !== undefined && Rooms[i].uuid === uuid) {
            for (let j = 0; j < Rooms[i].clients.length; ++j)
                if (findClientByUUID(Rooms[i].connection[j]) !== undefined)
                    findClientByUUID(Rooms[i].connection[j]).roomUUID = "~";
            Rooms.splice(i, 1);
            return true;
        }
    }
    console.log("Error in deleteRoomByUUID: couldn't delete the room");
    return false;
}

function removeClientFromRoom (clientUUID, roomObj) {
    if (roomObj !== undefined){
        for (let i = 0; i < roomObj.clients.length; ++i)
            if (roomObj.clients[i].uuid === clientUUID){
                roomObj.clients.splice(i, 1);
                if (roomObj.clients.length === 0) {
                    deleteRoomByUUID(roomObj.uuid);
                    console.log("delete room");
                }
                return true;
            }
    }
    console.log("Error in removeClientFromRoom: couldn't remove the client from room");
    return false;
}

function findClientByUUID (uuid) {
    let findClient = undefined;
    for (let i = 0; i < Clients.length; ++i) {
        if (Clients[i] !== undefined && Clients[i].uuid === uuid)
            findClient = Clients[i];
    }
    if (findClient === undefined)
        console.log("Error in findClientByUUID: couldn't find the client")
    return findClient;
}

function deleteClientByUUID (uuid) {
    for (let i = 0; i < Clients.length; ++i) {
        if (Clients[i] !== undefined && Clients[i].uuid === uuid) {
            Clients.splice(i, 1);
            return;
        }
    }
    console.log("Error in deleteClientByUUID: couldn't find the client")
    return undefined;
}

function refreshHallStatus () {
    let returnString = "1 " + String(Clients.length);
    for (let i = 0; i < Clients.length; ++i) {
        if (Clients[i] !== undefined)
            returnString += " " + Clients[i].uuid + " " + Clients[i].name + " " + Clients[i].roomUUID;
        else {
            returnString += " " + "~" + " " + "~";
            console.log("Error in refreshHallStatus: couldn't find Clients[" + String(i) + "]");
        }
    }
    returnString += " " + String(Rooms.length);
    for (let i = 0; i < Rooms.length; ++i) {
        if (Rooms[i] !== undefined)
            returnString += " " + Rooms[i].uuid + " " + Rooms[i].name + " " + String(Rooms[i].clients.length);
        else {
            returnString += " " + "~" + " " + "~" + "0";
            console.log("Error in refreshHallStatus: couldn't find Rooms[" + String(i) + "]");
        }
    }
    return returnString;
}

function refreshRoomStatus (roomUUID) {
    let returnString = "3", roomObj = findRoomByUUID(roomUUID);
    if (roomObj !== undefined){
        returnString += " " + roomObj.uuid + " " + roomObj.name + " " + String(roomObj.clients.length);
        for (let i = 0; i < roomObj.clients.length; ++i)
            returnString += " " + roomObj.clients[i].uuid + " " + roomObj.clients[i].name + " " + roomObj.clients[i].roomUUID;
        return returnString
    }
    console.log("Error in refreshRoomStatus: couldn't find the room");
    return undefined;
}

wsServer.on("open", function (){
    console.log("Server binds to port complete");
})

wsServer.on("connection", function (ws, req) {
    // console.log(Rooms);
    // if (Rooms[0] !== undefined)
    //     console.log(Rooms[0].clients);
    let clientAddress = req.connection.remoteAddress + ":" + req.connection.remotePort;
    console.log("New connection from " + clientAddress);
    let clientUUID = uuidv4(), clientName = clientUUID.substring(0, 8), roomUUID = "~";
    console.log("Applied uuid: " + clientUUID);
    console.log();
    Clients.push ({uuid : clientUUID, name : clientName, roomUUID : "", ws : ws});
    ws.send("0 " + clientUUID + " " + clientName + " " + roomUUID);
    ws.on("message", function(message) {
        const splitClientMsg = message.split(' ');
        switch (splitClientMsg[0]){
            case "ping":
            case "11":
                ws.send("10");
                break;

            case "refreshHall":
            case "1":
                ws.send(refreshHallStatus());
                ws.send("0 " + clientUUID + " " + clientName + " " + roomUUID);
                break;

            case "changeClient":
            case "0":
                clientName = (message.substring(14 - 11, message.length - 1)).split(" ").join("");
                // console.log(1);
                if (clientName === "") {
                    if (findClientByUUID(clientUUID) !== undefined) {
                        clientName = "Null";
                        findClientByUUID(clientUUID).name = clientName = clientUUID.substring(0, 8);
                    }
                    else
                        console.log("Error in changeClient: findClientByUUID returns undefined");
                }
                else {
                    if (findClientByUUID(clientUUID) !== undefined) {
                        findClientByUUID(clientUUID).name = clientName;
                    }
                    else
                        console.log("Error in changeClient: findClientByUUID returns undefined");
                }
                ws.send("0 " + clientUUID + " " + clientName + " " + roomUUID);
                ws.send(refreshHallStatus());
                break;

            case "createRoom":
            case "2":
                if (Rooms.length < 10) {
                    roomUUID = uuidv4()
                    let newRoom = {
                        uuid: roomUUID,
                        name: roomUUID.substring(0, 18),
                        clients: new Array({uuid: clientUUID, name: clientName, roomUUID: roomUUID, ws: ws}),
                        ifStart : false
                    };
                    if (findClientByUUID(clientUUID) !== undefined)
                        findClientByUUID(clientUUID).roomUUID = roomUUID;
                    else
                        console.log("Error in createRoom: findClientByUUID returns undefined");
                    Rooms.push(newRoom);
                    ws.send(refreshRoomStatus(roomUUID) + " force");
                }
                else
                    ws.send("errorMsg roomNumberExceedMaximum");
                break;

            case "joinRoom":
            case "3":
                let roomID = parseInt(splitClientMsg[1]);
                if (Rooms[roomID] !== undefined) {
                    roomUUID = Rooms[roomID].uuid;
                    Rooms[roomID].clients.push({uuid: clientUUID, name: clientName, roomUUID: roomUUID, ws: ws})
                    if (findClientByUUID(clientUUID) !== undefined)
                        findClientByUUID(clientUUID).roomUUID = roomUUID;
                    else
                        console.log("Error in joinRoom: findClientByUUID returns undefined");
                    // console.log(refreshRoomStatus(roomUUID));
                    ws.send(refreshRoomStatus(roomUUID) + " force");
                }
                else
                    console.log("Error in joinRoom: Rooms[roomID = " + String(roomID) + "] returns undefined");
                break;

            case "quitRoom":
            case "6":
                if (findRoomByUUID(roomUUID) !== undefined && findClientByUUID(clientUUID) !== undefined){
                    removeClientFromRoom(clientUUID, findRoomByUUID(roomUUID));
                    roomUUID = "~";
                    ws.send(refreshHallStatus() + " force");
                }
                else {
                    if (findRoomByUUID(roomUUID) === undefined)
                        console.log("Error in quitRoom: findRoomByUUID returns undefined");
                    else
                        console.log("Error in quitRoom: findClientByUUID returns undefined");
                }
                break;

            case "refreshRoom":
            case "4":
                if (findRoomByUUID(roomUUID) !== undefined)
                    ws.send(refreshRoomStatus(roomUUID));
                else
                    console.log("Error in refreshRoom: findRoomByUUID returns undefined");
                break;

            case "changeRoom":
            case "5":
                let roomName = (message.substring(3, message.length - 1)).split(" ").join("");
                if (roomName === "") {
                    if (findRoomByUUID(roomUUID) !== undefined) {
                        findRoomByUUID(roomUUID).name = roomUUID.substring(0, 8);
                    }
                    else
                        console.log("Error in changeRoom: findRoomByUUID returns undefined");
                }
                else {
                    if (findRoomByUUID(roomUUID) !== undefined) {
                        findRoomByUUID(roomUUID).name = roomName;
                    }
                    else
                        console.log("Error in changeRoom: findRoomByUUID returns undefined");
                }
                ws.send(refreshRoomStatus(roomUUID));
                break;

            case "startRoomGame":
            case "7":
                // console.log("startRoomGame");
                let room = findRoomByUUID(roomUUID)
                if (room !== undefined){
                    // console.log(room.clients[0]);
                    room.ifStart = true;
                    room.clients[0].ws.send("6 Host");
                    for (let i = 1; i < room.clients.length; ++i)
                        room.clients[i].ws.send("6 Client");
                }
                else
                    console.log("Error in startRoomGame: findRoomByUUID returns undefined");
                break;

            case "hostSendGameStatus":
            case "8":
                if (findRoomByUUID(roomUUID) !== undefined){
                    let room  = findRoomByUUID(roomUUID);
                    splitClientMsg[0] = "7"
                    for (let i = 1; i < room.clients.length; ++i)
                        room.clients[i].ws.send(splitClientMsg.join(" "));
                }
                break;

            case "clientSendControlStatus":
            case "9":
                if (findRoomByUUID(roomUUID) !== undefined){
                    let room = findRoomByUUID(roomUUID);
                    splitClientMsg[0] = "8";
                    room.clients[0].ws.send(splitClientMsg.join(" "));
                }
                break;

            case "gameClose":
            case "10":
                if (findRoomByUUID(roomUUID) !== undefined){
                    let room = findRoomByUUID(roomUUID);
                    splitClientMsg[0] = "9";
                    for (let i = 0; i < room.clients.length; ++i)
                        room.clients[i].ws.send(splitClientMsg.join(" "));
                }
                break;

            default:
                console.log("Error message unknown: " + message);
                break;
        }
    });

    ws.on("close", function(){
        // console.log(clientUUID, roomUUID);
        if ( findClientByUUID(clientUUID) !== undefined ) {
            if (findClientByUUID(clientUUID).roomUUID !== "~" && roomUUID !== "~") {
                if (findRoomByUUID(findClientByUUID(clientUUID).roomUUID) !== undefined) {
                    let room = findRoomByUUID(findClientByUUID(clientUUID).roomUUID);
                    if (room.ifStart === true){
                        for (let i = 0; i < room.clients.length; ++i)
                            if (room.clients[i].uuid !== clientUUID )
                                room.clients[i].ws.send("9 onePlayerDisconnect");
                        room.ifStart = false;
                    }
                    removeClientFromRoom(clientUUID, findRoomByUUID(findClientByUUID(clientUUID).roomUUID))
                }
                else
                    console.log("Error in onClose: roomUUID exists but findRoomByUUID returns undefined");
            }
        }
        else
            console.log("Error in onClose: findClientByUUID returns undefined");
        deleteClientByUUID(clientUUID);
        console.log("Connection close on " + clientAddress);
        console.log("Client uuid = " + clientUUID);
        console.log();
    })
});