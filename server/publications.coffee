
Meteor.publish "lists", ->
    Lists.find
        creator: this.userId

Meteor.publish "list", (listId) ->[
    Lists.find
        _id: listId,
    Items.find
        listId: listId
]

Meteor.publish "me", ->
    if this.userId
        Meteor.users.find {
            _id: this.userId
        }, {
            _id: 1
        }
    else
        return []
