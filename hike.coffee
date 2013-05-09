#!./node_modules/.bin/coffee
sqlite = require 'sqlite3'
dateFormat = require 'dateformat'

users = {}
chats = {}

## Get all users from hikeusers db to assign names to msisdn's
usersdb = new sqlite.Database('databases/hikeusers')
usersdb.serialize()
usersdb.each 'SELECT * FROM users', (err, row) ->
  if row.onhike == 1
    users[row.msisdn] = row.name
, ->
  usersdb.close()
  ## Get a list of chat conversations from the chats database
  chatsdb = new sqlite.Database('databases/chats')
  chatsdb.serialize
  chatsdb.each 'SELECT * FROM conversations', (err, row) ->
    chats[row.convid] = users[row.msisdn]
  , ->
    chatsdb.close()
    if process.argv.length < 3 or chats[process.argv[2]] == undefined
      console.log "Usage: hike.coffee <conversation ID>\n\nAvailable conversation IDs:"
      for convid, name of chats
        console.log "  #{convid}: Chat with #{name}"
      process.exit 1
    else
      export_chat process.argv[2]

strwrap = (string, length = 80) ->
  result = []
  while string.length > 0
    if string.length > length
      splitindex = string.lastIndexOf ' ', length
      result.push string.substring(0, splitindex)
      string = string.substring(splitindex + 1)
    else
      result.push string
      string = ''
  result

export_chat = (convid) ->
  chatpartner = chats[convid]

  chatsdb = new sqlite.Database('databases/chats')
  chatsdb.serialize()

  chatsdb.each "SELECT * FROM messages WHERE convid = #{convid} ORDER BY timestamp DESC", (err, row) ->
    sender = if row.mappedMsgId == -1 then 'me' else chatpartner
    date = dateFormat new Date(row.timestamp * 1000), 'yyyy-mm-dd HH:MM:ss'

    console.log "[#{date}] (#{sender}) #{row.message}"
  , ->
    chatsdb.close()

