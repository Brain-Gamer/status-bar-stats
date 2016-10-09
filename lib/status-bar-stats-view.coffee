module.exports =
class StatusBarStatsView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('status-bar-stats')
    @element.textContent = "Files: ? | Lines: ? | Words: ? | Characters: ?"

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  count: (files, lines, words, characters) ->
    @element.textContent = "Files: #{files} | Lines: #{lines} | Words: #{words} | Characters: #{characters}"
