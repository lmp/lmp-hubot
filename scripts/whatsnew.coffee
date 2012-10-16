# Description:
#   See what's new in git
#
# Dependencies:
#   "underscore": "1.3.3"
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   ewollesen

_ = require("underscore")

module.exports = (robot) ->

  robot.respond /what\'?s new\??$/i, (msg) ->
    msg
      .http("http://git.lmpcloud.com:9191/repos/degreesearch")
      .get() (err, res, body) ->
        commits = JSON.parse(body)
        summaries = _.map commits, (commit) -> [commit["id"].slice(0,8),
                                                commit["summary"] ? "No summary recorded",
                                                "http://github.com/lmp/degreesearch/commit/#{commit["id"]}"]
        text = _.inject summaries, (t, summary) ->
          t += summary.join(": ") + "\n"
        , ""
        msg.send text
