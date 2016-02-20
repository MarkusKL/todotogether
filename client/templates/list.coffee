
Template.item.helpers
    checkedState: ->
        if this.checked
            "checked"
        else
            ""

Template.itemsList.events
    'submit #formAdd': (e) ->
        e.preventDefault()
        form = $ '#formAdd'
        text = form.find '[name=text]'
        if !text.val()
            return
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
