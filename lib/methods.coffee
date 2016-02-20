
Meteor.methods
    "createList": (name) ->
        check name, String
        Lists.insert
            name: name
            creator: Meteor.userId()

    "addItem": (listId, text) ->
        check listId, String # Check permission to list
        check text, String
        Items.insert
            text: text
            creator: Meteor.userId()
            listId: listId

    "removeItem": (itemId) ->
        check itemId, String # Check permission to list
        Items.remove
            _id: itemId

    "checkItem": (itemId, state) ->
        check itemId, String # Check permission to list
        check state, Boolean
        Items.update {
            _id: itemId
        }, {
            $set: {
                checked: state
            }
        }
