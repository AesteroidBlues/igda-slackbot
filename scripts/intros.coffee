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
        log_intro robot, res if room == "introduce-yourself"

log_intro = (robot, res) ->
    user = res.envelope.user.name
    robot.brain.set "intro#{user.name}", res.message.text

    intro = robot.brain.get "intro#{user.name}"
    verb = if intro is null then "logged" else "updated"
    robot.send {user: {name: user.name}}, "Thanks #{user.name}, I've #{verb} your intro!"

send_intro = (robot, res) ->
    user = res.envelope.user.name
    intro = robot.brain.get "intro#{res.envelope.user.name}"
    if intro is null
        robot.send {user: {name: user.name}}, "Sorry, #{res.envelope.user.name} doesn't have an intro recorded."
    else
        robot.send {user: {name: user.name}}, intro
