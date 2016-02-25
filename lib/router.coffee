Router.configure
    layoutTemplate: "layout",
    loadingTemplate: "loading",
    notFoundTemplate: "notFound"
    waitOn: ->
        Meteor.subscribe "me"

Router.route '/',
    name: 'front'
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
        users: Meteor.users.find()

requireLogin = ->
    if Meteor.loggingIn()
        this.render this.loadingTemplate
    else if not Meteor.userId()
        this.router.go('/')
    this.next()

Router.onBeforeAction requireLogin,
    except: ['/']
