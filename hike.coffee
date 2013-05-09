#!./node_modules/.bin/coffee
sqlite = require 'sqlite3'
dateFormat = require 'dateformat'
pad = require 'pad'
Getopt = require 'node-getopt'

getopt = new Getopt([
  ['h', 'help', 'displays this help'],
  ['n', 'name=DISPLAYNAME', 'set DISPLAYNAME instead of "me" in output'],
  ['p', 'partner=DISPLAYNAME', 'set DISPLAYNAME instead of contacts name in output']
])
getopt.setHelp("Usage: ./#{process.argv[1].match(/(?:.*[\/\\])?(.*)$/)[1]} [OPTIONS] [conversation ID]\n\n[[OPTIONS]]\n")
opt = getopt.bindHelp().parseSystem()

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
    if opt.argv.length < 1 or chats[opt.argv[0]] == undefined
      getopt.showHelp()
      console.log "\nAvailable conversation IDs:"
      for convid, name of chats
        console.log "  #{convid}: Chat with #{name}"
      process.exit 1
    else
      export_chat opt.argv[0]

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
  chatpartner = opt.options.partner ? chats[convid]
  me = opt.options.name ? "me"

  chatsdb = new sqlite.Database('databases/chats')
  chatsdb.serialize()

  indentlevel = 25 + chatpartner.length

  chatsdb.each "SELECT * FROM messages WHERE convid = #{convid} ORDER BY timestamp DESC, msgid DESC", (err, row) ->
    sender = if row.mappedMsgId == -1 then me else chatpartner
    date = dateFormat new Date(row.timestamp * 1000), 'yyyy-mm-dd HH:MM:ss'

    message = "#{row.message}"
    lines = strwrap(message.replace(/\n/g, " "), 140)

    linestart = pad("[#{date}] (#{sender})", indentlevel)
    while lines.length > 0
      console.log "#{linestart} #{lines.shift()}"
      linestart = pad(' ', indentlevel)
  , ->
    chatsdb.close()

