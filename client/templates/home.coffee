
Template.listsList.helpers
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
