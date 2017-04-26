// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

var editor_div = document.getElementById("editor");
var editor = ace.edit("editor");
var silent = false;
const user = "user" + Math.floor((Math.random() * 1000000) + 1);
const bloc_id = editor_div.getAttribute("data-id");
var bloc_rev = editor_div.getAttribute("data-rev");

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("document:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on('shout', (r) => {
  if (r.user === user) return;
  if (bloc_id !== r.bloc_id) console.log("errrorrr");
  silent = true;
  bloc_rev = r.rev;
  editor.getSession().getDocument().applyDeltas([r.delta]);
});

editor.on('change', (e) => {
  var old_silent = silent;
  silent = false;
  if (old_silent) return;

  channel.push('shout', {bloc_id: bloc_id, rev: bloc_rev, user, delta: e});
});

export default socket


