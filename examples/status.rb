require_relative "../lib/whirly"

Whirly.start status: "Initial status, passed when starting Whirly"
sleep 3
Whirly.status = "Status update"
sleep 3
Whirly.stop
