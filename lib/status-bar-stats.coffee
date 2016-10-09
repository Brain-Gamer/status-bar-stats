StatusBarStatsView = require './status-bar-stats-view'
{CompositeDisposable} = require 'atom'

module.exports = StatusBarStats =

  config:
    activateOnStart:
      type: 'string'
      default: 'Show on start'
      enum: ['Show on start', 'Remember last setting', 'Don\'t show on start']
    refreshRate:
      type: 'integer'
      default: 100
      minimum: 1
    enableFiles:
      type: 'boolean'
      default: true
    enableLines:
      type: 'boolean'
      default: true
    enableWords:
      type: 'boolean'
      default: true
    enableCharacters:
      type: 'boolean'
      default: true

  active: false

  activate: (state) ->
    @state = state

    @subscriptions = new CompositeDisposable
    @statusBarStatsView = new StatusBarStatsView()
    @statusBarStatsView.init()
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'status-bar-stats:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'status-bar-stats:restart': => @restart()

  deactivate: ->
    console.log 'Stats were deactivated'
    @subscriptions.dispose()
    @statusBarStatsView.destroy()
    @statusBarTile?.destroy()

  serialize:->
    {
      activateOnStart: atom.config.get('status-bar-stats.activateOnStart'),
      active: @active
    }

  toggle: (active = undefined) ->
    active = ! !!@active if !active?

    if active
      console.log 'Stats were toggled on'
      @statusBarStatsView.activate()
      @statusBarTile = @statusBar.addLeftTile
        item: @statusBarStatsView, priority: -1
    else
      @statusBarTile?.destroy()
      @statusBarStatsView?.deactivate()

    @active = active

  restart: ->
    @toggle false
    @toggle true

  consumeStatusBar: (statusBar) ->
    @statusBar = statusBar
    # auto activate as soon as status bar activates based on configuration
    @activateOnStart(@state)

  activateOnStart: (state) ->
    switch state.activateOnStart
      when 'Remember last setting' then @toggle state.active
      when 'Show on start' then @toggle true
      else @toggle false
