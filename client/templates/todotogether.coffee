
Template.content.helpers
    lists: -> Lists.find()

Template.content.events
    'click .buttonRemoveAll': (e) ->
        e.preventDefault()
        Meteor.call("removeAll")

    'submit #formNewList': (e) ->
        e.preventDefault()
        form = $ '#formNewList'
        name = form.find '[name=name]'
        if !name.val()
            return
        Lists.insert
            name: name.val()
            creator: Meteor.userId()
        name.val ""
