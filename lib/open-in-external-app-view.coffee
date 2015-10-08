_ = require 'underscore-plus'
{TextEditor} = require 'atom'

module.exports =
class OpenInExternalAppView
  constructor: (config={}, serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('open-in-external-app')
    # Create input view
    @installInput()
    # Create list elements
    @installLists(config)

  installInput: () ->
    @inputEditor = new TextEditor({mini: true, placeholderText:"test"})
    @inputView = atom.views.getView(@inputEditor)
    @element.appendChild(@inputView)

  installLists: (config) ->
    lines = _.keys(config).map (k) -> "#{k.toUpperCase()} : #{config[k]}<br>"
    content = lines.join('')

    appsList = document.createElement('div')
    appsList.insertAdjacentHTML('beforeend', content)
    appsList.classList.add('apps-list')
    @element.appendChild(appsList)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
