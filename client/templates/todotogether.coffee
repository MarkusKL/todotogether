
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


Template.itemList.events
    'submit #formAdd': (e) ->
        e.preventDefault()
        form = $ '#formAdd'
        text = form.find '[name=text]'
        Items.insert
            text: text.val()
            creator: Meteor.userId()
            listId: this.list._id
        text.val("")

Template.item.events
    'click .removeItem': (e) ->
        id = e.currentTarget.dataset.id
        Items.remove
            _id: this._id

    'click input': (e) ->
        state = e.currentTarget.checked
        Items.update {
            _id: this._id
        }, {
            $set:
                checked: state
        }
