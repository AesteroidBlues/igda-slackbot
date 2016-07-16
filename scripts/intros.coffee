# Description:
#   Load and store introductory messages from members by listening to the #introduce-yourself
#   channel on Slack.
#
# Commands:
#   hubot intro <username> Get the introduction message of a user.
#   hubot set intro <username> <intro> - Manually set a user's intro. Requires `mod` permissions
#
# Notes:
#   /shrug

module.exports = (robot) ->
    # Hear any string from any source and act if it looks like `!intro (@)username`
    robot.respond /intro\s*@{0,1}(.*)/i, (res) ->
        send_intro robot, res, res.match[1]

    # Hear any string from any source
    robot.hear /^(?!.*(!intro))/i, (res) ->
        room = res.message.room
        # Only log the intro if the room this msg came from was `introduce-yourself`
        log_intro robot, res if room == "introduce-yourself"

    robot.respond /set intro\s+@?(\S+)\s+(.*)/i, (res) ->
        unless res.envelope.user.slack.is_admin
            res.send "Sorry, you do not have permission to set a user's intro."
            return;
        set_intro robot, res, res.match[1], res.match[2]


log_intro = (robot, res) ->
    # Silly logic to see if we should use the word `logged` or `updated` :|
    intro = robot.brain.get "intro#{res.envelope.user.name}"
    verb = if intro is null then "logged" else "updated"

    # Save the text to the database
    robot.brain.set "intro#{res.envelope.user.name}", res.message.text

    # PM the user to let them know we got their message.
    params = {room: res.envelope.user.name}
    response = "Thanks #{res.envelope.user.slack.profile.first_name}, I've #{verb} your intro!"

    robot.send params, response

set_intro = (robot, res, userName, intro) ->
    # Don't save entries for non-existant users
    unless robot.brain.userForName userName
        res.send "#{userName} is not a user"
        return

    # Save the text to the database
    robot.brain.set "intro#{userName}", intro

    response = "I've set the intro for #{userName}";

    res.send response

send_intro = (robot, res, user) ->
    # Try to get the intro out of the database
    intro = robot.brain.get "intro#{user}"
    params = {room: res.envelope.user.name}

    # If it doesn't exist, let the user know, otherwise send it to them
    if intro is null
        robot.send params, "Sorry, #{user} doesn't have an intro recorded."
    else
        robot.send params, "#{user}: #{intro}"
