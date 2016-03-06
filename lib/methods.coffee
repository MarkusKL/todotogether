
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
            listId: listId,
            created: new Date()

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

    "setPriority": (itemId, priority) ->
        check itemId, String
        check Meteor.userId(), String
        checkListAccess findListId itemId
        if Match.test priority, String
            priority = undefined
        else
            check priority, Number

        Items.update {
            _id: itemId
        }, {
            $set: priority: priority
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
        if not Meteor.isServer
            return; # Does not make sense to simulate on the client
            # Maybe this is an anti-pattern?
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

    "revokeAccess": (listId, userId) ->
        check listId, String
        check userId, String
        check Meteor.userId(), String
        if userId == Meteor.userId()
            throw new Meteor.Error(403, "Can not revoke the list creators access")
        Lists.update {
            _id: listId
            creator: Meteor.userId()
        }, {
            $pull: access: userId
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
