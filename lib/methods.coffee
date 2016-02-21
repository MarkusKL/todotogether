
Meteor.methods
    "createList": (name) ->
        check name, String
        Lists.insert
            name: name
            creator: Meteor.userId()
            access: [Meteor.userId()]

    "addItem": (listId, text) ->
        check listId, String
        checkListAccess(listId)
        check text, String
        Items.insert
            text: text
            creator: Meteor.userId()
            listId: listId

    "removeItem": (itemId) ->
        check itemId, String
        checkListAccess(findListId(itemId))
        Items.remove
            _id: itemId

    "checkItem": (itemId, state) ->
        check itemId, String
        check state, Boolean
        checkListAccess(findListId(itemId))
        Items.update {
            _id: itemId
        }, {
            $set: {
                checked: state
            }
        }

    "giveAccess": (listId, username) ->
        check listId, String
        check username, String
        user = Accounts.findUserByUsername username
        check user, Object

        Lists.update {
            _id: listId
            creator: Meteor.userId()
        }, {
            $addToSet: access: user._id
        }

findListId = (itemId) ->
    Items.findOne({
        _id: itemId
    }, {
        listId: 1
    }).listId

checkListAccess = (listId) ->
    list = Lists.findOne
        _id: listId
        access: $all: [Meteor.userId()]
    check list, Object
