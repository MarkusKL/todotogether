
Template.content.helpers
    items: -> Items.find()
    lists: -> Lists.find()

Template.content.events
    'submit #formAdd': (e) ->
        e.preventDefault()
        input = $('.textInput')
        Items.insert
            text: input.val()
            creator: Meteor.userId()
        input.val("")

    'click .buttonRemoveAll': (e) ->
        e.preventDefault()
        Meteor.call("removeAll")

    'click .removeItem': (e) ->
        id = e.currentTarget.dataset.id
        Items.remove
            _id: id

    'submit #formNewList': (e) ->
        e.preventDefault()
        form = $ '#formNewList'
        name = form.find '[name=name]'
        if !name
            return
        Lists.insert
            name: name.val()
            creator: Meteor.userId()
        name.val ""

Template.item.helpers
    creatorUsername: ->
        Meteor.users.findOne(this.creator).username if this.creator?
    checkedState: ->
        return this.checked? "checked" : ""

Template.item.events
    'click input': (e) ->
        state = e.currentTarget.checked
        Items.update {
            _id: this._id
        }, {
            $set:
                checked: state
        }
