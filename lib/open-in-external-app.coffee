OpenInExternalAppView = require './open-in-external-app-view'
{CompositeDisposable} = require 'atom'

module.exports = OpenInExternalApp =
  openInExternalAppView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @openInExternalAppView = new OpenInExternalAppView(state.openInExternalAppViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @openInExternalAppView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'open-in-external-app:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @openInExternalAppView.destroy()

  serialize: ->
    openInExternalAppViewState: @openInExternalAppView.serialize()

  toggle: ->
    console.log 'OpenInExternalApp was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
