
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
    }
    if !list
        return []
    [
        Lists.find
            _id: listId,
        Items.find
            listId: listId
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

Meteor.publish 'allItems', ->
    if !this.userId
        return []
    # The listIds are not reaktive
    listIds = _.pluck(Lists.find({
        access: $all: [this.userId]
    }, {
        _id: 1
    }).fetch(),'_id')

    Items.find
        listId: $in: listIds


Meteor.publish "userInfo", (userId) ->
    check userId, String
    return Meteor.users.find {
        _id: userId
    }, {
        username: 1
    }
