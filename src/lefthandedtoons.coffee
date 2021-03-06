# Description:
#   Get the latest Left Handed Toons
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect: "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot lht - The latest Left-Handed Toon
#   hubot lht random - A random Left-Handed Toon
#
# Author:
#   gkoo

htmlparser = require "htmlparser"
Select     = require("soupselect").select

module.exports = (robot) ->
  getComicSrc = (msg, body) ->
    handler = new htmlparser.DefaultHandler()
    parser = new htmlparser.Parser(handler)
    parser.parseComplete(body)

    title = Select handler.dom, ".comictitle a"
    titleText = title[0].children[0].data
    img = Select handler.dom, ".comicimage"
    comic = img[0].attribs

    msg.send titleText
    msg.send comic.src

  robot.respond /lht$/i, (msg) ->
    msg.http("http://www.lefthandedtoons.com/")
        .get() (err, res, body) ->
          getComicSrc(msg, body)

  robot.respond /lht random$/i, (msg) ->
    msg.http("http://www.lefthandedtoons.com/")
        .get() (err, res, body) ->
          handler = new htmlparser.DefaultHandler()
          parser = new htmlparser.Parser(handler)
          parser.parseComplete(body)

          title = Select handler.dom, ".comictitle a"
          titleText = title[0].children[0].data
          titleHref = title[0].attribs.href
          start = titleHref.indexOf('com') + 4
          max = parseInt(titleHref.substring(start), 10)
          comicNum = Math.floor((Math.random()*max)+1)
          msg.http("http://www.lefthandedtoons.com/#{comicNum}/")
              .get() (err, res, body) ->
                getComicSrc(msg, body)
