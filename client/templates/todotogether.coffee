
Template.listsList.helpers
    lists: -> Lists.find()

Template.content.events
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
