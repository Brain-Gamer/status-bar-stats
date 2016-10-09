class StatusBarStats extends HTMLElement
  init: ->
    @classList.add('status-bar-stats', 'inline-block')
    @activate()


  activate: ->
    @intervalId = setInterval @updateClock.bind(@), atom.config.get('status-bar-stats.refreshRate')

  deactivate: ->
    clearInterval @intervalId

  updateStats: ->
    conf = atom.config
    editor = atom.workspace.getActiveTextEditor()
    if editor?
      text = editor.getText()
      display = ""

      conf.set('status-bar-stats.enableFiles', false)

      conf_files = conf.get('status-bar-stats.enableFiles')
      conf_lines = conf.get('status-bar-stats.enableLines')
      conf_words = conf.get('status-bar-stats.enableWords')
      conf_characters = conf.get('status-bar-stats.enableCharacters')

      if conf_files
        files = 1
        display = "#{display}Files: #{files}"

      if conf_lines
        lines = text.split(/.+/g).length
        if !!display
          display = "#{display} | Lines: #{lines}"
        else
          display = "#{display}Lines: #{lines}"

      if conf_words
        words = text.split(/\w+/g).length
        if !!display
          display = "#{display} | Words: #{words}"
        else
          display = "#{display}Words: #{words}"

      if conf_characters
        characters = text.split(/\S/g).length
        if !!display
          display = "#{display} | Characters: #{characters}"
        else
          display = "#{display}Characters: #{characters}"

      display

  updateClock: ->
    @textContent = @updateStats()

module.exports = document.registerElement('status-bar-stats', prototype: StatusBarStats.prototype, extends: 'div')
