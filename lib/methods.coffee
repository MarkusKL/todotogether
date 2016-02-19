
Meteor.methods
    'removeAll': ->
        Items.remove({})
        Lists.remove({})
