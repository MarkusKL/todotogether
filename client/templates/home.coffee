
Template.panelListsList.helpers
    lists: -> Lists.find()

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

Template.layout.onRendered ->
    this.find('#main')._uihooks =
        insertElement: (node, next) ->
            $(node).hide().insertBefore(next).fadeIn()
        removeElement: (node) ->
            $(node).fadeOut ->
                $(this).remove()
