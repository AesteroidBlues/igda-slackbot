# Description:
#   Load and store introductory messages from members by listening to the #introduce-yourself
#   channel on Slack.
#
# Notes:
#   /shrug

module.exports = (robot) ->
    #Fires when a user enters a channel hubot is in
    robot.enter (res) ->
    	user_id = res.message.user.id
    	unless robot.brain.userForName user_id
    		greet_user robot, res;

greet_user = (robot, res) ->
	user_first = res.envelope.user.slack.profile.first_name
	params = { room: res.message.user.name }
	
	greeting = "
				Hi there #{user_first}, welcome to the SD Game Dev Slack channel! We 
				hope you enjoy your stay! Please take a moment to introduce introduce
				yourself to the community in the #introduce-yourself channel! I'll 
				save your introduction message for later reference! If you'd like to
				see someone else's introduction, just private message me with
				`!intro @username` and I'll get it for you!
				"
	robot.send params, greeting

