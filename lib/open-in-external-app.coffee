OpenInExternalAppView = require './open-in-external-app-view'
{CompositeDisposable} = require 'atom'
open = require 'open'
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

    @subscriptions.add atom.commands.add @view.element,
      'core:cancel': (event) =>
        @cancel()
        event.stopPropagation()
    # Execute the open
    @subscriptions.add @view.inputEditor.onDidChange => @maybeOpen()
    @konfig = config

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @view.destroy()

  maybeOpen: () ->
    text = @view.inputEditor.getText()
    return if text == ''
    if _.contains(_.keys(@konfig), text)
      @open(@konfig[text])
    else
      @view.inputEditor.setText('')

  open: (app) ->
    uri = atom.workspace.getActivePaneItem()?.getPath?()
    if uri
      open uri, app, (e, out, err) ->
        if e
          atom.notifications.addError "Cannot open with #{app}",
            detail: out + err
        else
          atom.notifications.addSuccess("Opened with #{app}")
      @cancel()

  serialize: ->

  toggle: ->
    if @modalPanel.isVisible()
      @cancel()
    else
      @show()

  show: ->
    @previousFocusedElement = document.activeElement
    @modalPanel.show()
    @view.inputEditor.setText('')
    @view.inputView.focus()

  cancel: ->
    @modalPanel.hide() if @modalPanel.isVisible()
    if @previousFocusedElement
      atom.views.getView(@previousFocusedElement).focus()
      @previousFocusedElement = null
