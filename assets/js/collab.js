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
var bloc_rev = parseInt(editor_div.getAttribute("data-rev"));

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("document:lobby", {bloc_id, parent_rev: bloc_rev})
channel.join({rev: bloc_rev})
  .receive("ok", resp => {

    resp.forEach((e) => {
      var rev = JSON.parse(e);
      bloc_rev = rev.rev;
      silent = true;
      editor.getSession().getDocument().applyDeltas([rev.delta]);
    });
    // console.log("Joined successfully", resp)
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on('shout', (r) => {
  if (r.user === user) return;

  console.log(`Applying rev ${r.rev}`);
  bloc_rev = r.rev;
  silent = true;
  editor.getSession().getDocument().applyDeltas([r.delta]);
});

editor.on('change', (e) => {
  var old_silent = silent;
  silent = false;
  if (old_silent) return;

  console.log(`Sending rev ${bloc_rev}`);
  channel.push('shout', {bloc_id, parent_rev: bloc_rev, user, delta: e});
  bloc_rev = bloc_rev + 1;
});

export default socket
