
Meteor.publish "lists", ->
    if this.userId
        return Lists.find
            access: $all: [this.userId]
    else
        return []

Meteor.publish "list", (listId) ->
    list = Lists.findOne {
        _id: listId
        access: $all: [this.userId]
    }, {
        access: 1
    } # No update
    if !list
        return []
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
        return Meteor.users.find {
            _id: this.userId
        }, {
            _id: 1
        }
    else
        return []
