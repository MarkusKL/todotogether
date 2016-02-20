
Meteor.publish "lists", ->
    Lists.find
        creator: this.userId

Meteor.publish "list", (listId) ->[
    Lists.find
        _id: listId,
    Items.find
        listId: listId
]
