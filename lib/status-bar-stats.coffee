StatusBarStatsView = require './status-bar-stats-view'
{CompositeDisposable} = require 'atom'

module.exports = StatusBarStats =

  active: false
  statusBarStatsView: null
  statusBar: null
  subscriptions: null

  activate: (state) ->
    @statusBarStatsView = new StatusBarStatsView(state.statusBarStatsViewState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'status-bar-stats:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'status-bar-stats:refresh': => @refresh()

  deactivate: ->
    @statusBarTile?.destroy()
    @statusBarTile = null
    @subscriptions.dispose()
    @statusBarStatsView.destroy()

  serialize: ->
    statusBarStatsViewState: @statusBarStatsView.serialize()

  toggle: ->
    console.log 'StatusBarStats was toggled!'

    if @active
      @statusBarTile?.destroy()
      @statusBarTile = null
      @active = false
    else
      @statusBarTile = @statusBar.addLeftTile
        item: @statusBarStatsView, priority: 100
      @refresh()
      @active = true


  refresh: ->
    console.log 'StatusBarStats was refreshed!'

    editor = atom.workspace.getActiveTextEditor()
    text = editor.getText()

    files = 1
    lines = text.split(/.+/g).length
    words = text.split(/\w+/g).length
    characters = text.split(/\S/g).length

    @statusBarStatsView.count(files,lines,words,characters)

    consumeStatusBar: (statusBar) ->
      @statusBar = statusBar
