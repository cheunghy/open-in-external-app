OpenInExternalAppView = require './open-in-external-app-view'
{CompositeDisposable} = require 'atom'
_ = require('underscore-plus')

module.exports = OpenInExternalApp =
  view: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    config = atom.config.get 'open-in-external-app'
    unless config
      config =
        "e": "Emacs"
        "s": "Sublime Text"
        "t": "TextMate"
        "f": "Finder"
    @view = new OpenInExternalAppView(config, state)

    @modalPanel = atom.workspace.addModalPanel
      item: @view.getElement()
      visible: false

    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'open-in-external-app:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace',
      'open-in-external-app:open': => @open()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @view.destroy()

  serialize: ->

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
      @modalPanel.visible = false
    else
      @modalPanel.show()
      @modalPanel.visible = true

  open: ->
