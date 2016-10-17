// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

let guardianToken = $('meta[name="guardian_token"]').attr('content')
let socket = new Socket("/socket", {params: {guardian_token: guardianToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let user_id = $('meta[name="user_id"]').attr('content')
let channel = socket.channel(`users:${user_id}`, {})

channel.on("message", payload => {
  let flashContainer = $('#flashes')
  let flash_msg = `
    <div class='alert alert-success'>
      <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
      ${payload.body}
    </div>
  `

  flashContainer.append(flash_msg)
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
