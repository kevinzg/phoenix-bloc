// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

var editor = ace.edit("editor");
var silent = false;
var user = "user" + Math.floor((Math.random() * 1000000) + 1);

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("document:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on('shout', (r) => {
  if (r.user === user) return;

  silent = true;
  editor.getSession().getDocument().applyDeltas([r.delta]);
});

editor.on('change', (e) => {
  var old_silent = silent;
  silent = false;
  if (old_silent) return;

  channel.push('shout', {user, delta: e});
});

export default socket


