# Description:
#   Load and store introductory messages from members by listening to the #introduce-yourself
#   channel on Slack.
#
# Notes:
#   /shrug

module.exports = (robot) ->
    robot.hear /!intro (.*)/i, (res) ->
        send_intro (robot, msg.envelope.user)

    robot.hear /(.*)/i, (res) ->
        room = res.message.room
        log_intro (robot, msg) if room == "introduce-yourself"

log_intro = (robot, msg) ->
    robot.brain.set msg.envelope.user, msg.
    msg.send "Thanks, #{msg.envelope.user}, I've recorded your intro :)"

send_intro = (robot, user) ->
    intro = robot.get user
    msg.send(intro)
