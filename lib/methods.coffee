
Meteor.methods
    "createList": (name) ->
        check name, String
        check Meteor.userId(), String
        Lists.insert
            name: name
            creator: Meteor.userId()
            access: [Meteor.userId()]

    "deleteList": (listId) ->
        check listId, String
        Lists.remove
            _id: listId,
            creator: Meteor.userId()

    "addItem": (listId, text) ->
        check listId, String
        check Meteor.userId(), String
        checkListAccess(listId)
        check text, String
        Items.insert
            text: text
            creator: Meteor.userId()
            listId: listId

    "changeItemText": (itemId, text) ->
        check itemId, String
        check Meteor.userId(), String
        checkListAccess findListId itemId
        check text, String
        Items.update {
            _id: itemId
        }, {
            $set: text: text
        }

    "removeItem": (itemId) ->
        check itemId, String
        check Meteor.userId(), String
        checkListAccess(findListId(itemId))
        Items.remove
            _id: itemId

    "checkItem": (itemId, state) ->
        check itemId, String
        check state, Boolean
        check Meteor.userId(), String
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
        check Meteor.userId(), String
        user = Accounts.findUserByUsername username
        check user, Object

        Lists.update {
            _id: listId
            creator: Meteor.userId()
        }, {
            $addToSet: access: user._id
        }

    "revokeAccess": (listId, username) ->
        check listId, String
        check username, String
        check Meteor.userId(), String
        user = Accounts.findByUsername username
        check user, Object

        Lists.update {
            _id: listId
            creator: Meteor.userId()
        }, {
            $pull: user._id
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
