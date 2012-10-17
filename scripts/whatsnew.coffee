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

        _.each commits, (commit) ->
          shortSha = commit.id.slice(0, 8)
          summary = _.first commit.summary.split("\n")

          msg.http("http://git.io")
            .post("url=#{makeLink(commit.id)}") (err, resp) ->
              unless err
                msg.send "#{shortSha}: #{summary} #{resp.headers.location}"

  makeLink = (sha) ->
    "http://github.com/lmp/degreesearch/commit/#{sha}"