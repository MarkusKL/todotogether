Router.configure
    layoutTemplate: "layout",
    loadingTemplate: "loading",
    notFoundTemplate: "notFound"
    waitOn: ->
        Meteor.subscribe "me"

Router.route '/',
    name: 'main'
    waitOn: ->
        Meteor.subscribe "lists"

Router.route '/list/:_id',
    name: 'list'
    waitOn: ->
        Meteor.subscribe "list", this.params._id
    data: ->
        list: Lists.findOne this.params._id
        items: Items.find
            listId: this.params._id
