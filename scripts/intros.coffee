# Description:
#   Load and store introductory messages from members by listening to the #introduce-yourself
#   channel on Slack.
#
# Notes:
#   /shrug

module.exports = (robot) ->
    robot.hear /!intro\s*@{0,1}(.*)/i, (res) ->
        send_intro robot, res, res.match[1]

    robot.hear /^(?!.*(!intro))/i, (res) ->
        room = res.message.room
        log_intro robot, res if room == "introduce-yourself"

log_intro = (robot, res) ->
    intro = robot.brain.get "intro#{res.envelope.user.name}"
    verb = if intro is null then "logged" else "updated"

    robot.brain.set "intro#{res.envelope.user.name}", res.message.text

    params = {room: res.envelope.user.name}
    response = "Thanks #{res.envelope.user.slack.profile.first_name}, I've #{verb} your intro!"

    robot.send params, response

send_intro = (robot, res, user) ->
    intro = robot.brain.get "intro#{user}"
    params = {room: res.envelope.user.name}

    if intro is null
        robot.send params, "Sorry, #{user} doesn't have an intro recorded."
    else
        robot.send params, "#{intro}"
