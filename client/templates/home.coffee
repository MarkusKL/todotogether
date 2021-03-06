
Template.panelListsListBody.helpers
    lists: -> Lists.find()
    classCurrentList: ->
        if Template.parentData()
            if this._id is Template.parentData().listId then 'list-group-item-info' else ''

Template.formCreateList.events
    'submit #formNewList': (e) ->
        e.preventDefault()
        form = $ '#formNewList'
        name = form.find '[name=name]'
        if !name.val()
            return
        Meteor.call "createList", name.val()
        name.val ""

Template.navbar.helpers
    'isRoute': (name)->
        return if Router.current().route.getName() is name then 'active' else ''

Template.panelListsList.onCreated ->
    this.subscribe('lists')

Template.userLayout.onRendered ->
    this.find('#main')._uihooks =
        insertElement: (node, next) ->
            $(node).hide().insertBefore(next).fadeIn()
        removeElement: (node) ->
            $(node).fadeOut ->
                $(this).remove()

Template.panelItemCollection.helpers
    'items': ->
        Items.find {
            checked: false
        }, {
            sort: [["priority","desc"],["created","asc"]]
        }

Errors.show = (text) ->
    if(!text)
        return
    Blaze.renderWithData Template.error, text: text, document.getElementById "errors"

Template.error.onRendered ->
    div = $ '.error-msg'
    height = (-div.outerHeight(true))+"px"
    div
        .css('top', height)
        .animate({top: 0}, "ease-out")
        .delay(3000)
        .animate({top: height}, "ease-in", ->
            $(this).remove())
