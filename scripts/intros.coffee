# Description:
#   Load and store introductory messages from members by listening to the #introduce-yourself
#   channel on Slack.
#
# Notes:
#   /shrug

module.exports = (robot) ->
    robot.hear /!intro (.*)/i, (res) ->
        send_intro robot, res

    robot.hear /^(?!.*(!intro))/i, (res) ->
        room = res.message.room
        console.log room
        log_intro robot, res if room == "introduce-yourself"

log_intro = (robot, res) ->
    robot.brain.set "intro#{res.envelope.user.name}", res.message.text
    intro = robot.brain.get "intro#{res.envelope.user.name}"
    verb = if intro is null then "logged" else "updated"
    res.send "Thanks #{res.envelope.user.name}, I've #{verb} your intro!"

send_intro = (robot, res) ->
    intro = robot.brain.get "intro#{res.envelope.user.name}"
    if intro is null
        res.send "Sorry, #{res.envelope.user.name} doesn't have an intro recorded."
    else
        res.send intro
