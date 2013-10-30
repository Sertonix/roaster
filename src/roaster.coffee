#!/usr/bin/env coffee

Fs = require 'fs'
Path = require 'path'
marked = require 'marked'
emoji = require 'emoji-images'
taskLists = require 'task-lists'
toc = require 'toc'

emojiFolder = Path.join(Path.dirname( require.resolve('emoji-images') ), "pngs")

options =
  isFile: false
  header: '<h<%= level %>><a name="<%= anchor %>" class="anchor" href="#<%= anchor %>"><span class="octicon octicon-link"></span></a><%= header %></h<%= level %>>'

module.exports = (file, opts, callback) ->
  conversion = (data) ->
    emojified = emoji(data, emojiFolder, 20).replace(/\\</g, "&lt;")
    mdToHtml = marked(emojified)
    contents = taskLists(mdToHtml)
    contents = toc.process(contents, options)

  if typeof opts is 'function'
    callback = opts
  else
    for key of opts
      options[key] = opts[key]

  marked.setOptions(options)

  if options.isFile
    Fs.readFile file, "utf8", (err, data) =>
      callback(err, conversion(data))
  else
    callback(null, conversion(file))
