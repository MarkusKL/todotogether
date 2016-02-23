
Meteor.publish "lists", ->
    Lists.find
        access: $all: [this.userId]

Meteor.publish "list", (listId) ->
    list = Lists.findOne {
        _id: listId
        access: $all: [this.userId]
    }, {
        access: 1
    } # No update
    check list, Object # Manage subscription denial better
    [
        Lists.find
            _id: listId,
        Items.find
            listId: listId,
        Meteor.users.find({
            _id: $in: list.access
        }, {
            username: 1
        })
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
