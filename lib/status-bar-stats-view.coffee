class StatusBarStats extends HTMLElement
  init: ->
    @classList.add('status-bar-stats', 'inline-block')
    @activate()


  activate: ->
    @intervalId = setInterval @updateClock.bind(@), atom.config.get('status-bar-stats.refreshRate')

  deactivate: ->
    clearInterval @intervalId

  updateStats: ->
    editor = atom.workspace.getActiveTextEditor()
    if editor?
      text = editor.getText()
      conf = atom.config.get('status-bar-stats')
      display = []

      if conf.enableFiles
        files = 1
        display.push "Files: #{files}"

      if conf.enableLines
        lines = text.split(/.+/g).length
        display.push "Lines: #{lines}"

      if conf.enableWords
        words = text.split(/\w+/g).length
        display.push "Words: #{words}"

      if conf.enableCharacters
        characters = text.split(/\S/g).length
        display.push "Characters: #{characters}"

      display.join(" | ")

  updateClock: ->
    atom.config.set('status-bar-stats.enableFiles', false)
    @textContent = @updateStats()

module.exports = document.registerElement('status-bar-stats', prototype: StatusBarStats.prototype, extends: 'div')
