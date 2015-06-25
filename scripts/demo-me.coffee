# Description:
#   Hubot delivers a random demoscene production of any type. Uses data from http://demozoo.org
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot demo me - Displays a random demoscene production.
#
# Author:
#   captain jinx

module.exports = (robot) ->
  robot.respond /demo me/i, (msg) ->
    
    apiUri = "http://demozoo.org/api/v1/productions/"

    msg.http(apiUri).get() (err, res, body) ->
      result = JSON.parse(body)
      totalCount = result.count
      pageSize = result.results.length
      pageCount = Math.floor(totalCount / pageSize)
      randomPage = Math.floor(Math.random() * pageCount) + 1

      msg.http("#{apiUri}?page=#{randomPage}").get() (err, res, body) ->
        production = msg.random JSON.parse(body).results

        name = (x) -> x.name
        joined = (list) -> (list.map name).join '/'

        authors = joined production.author_nicks
        types = joined production.types

        msg.send "Check out this #{types} *#{production.title}* from #{authors}"
        msg.send "http://demozoo.org/productions/#{production.id}/"
