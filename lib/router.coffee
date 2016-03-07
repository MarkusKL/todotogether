Router.configure
    layoutTemplate: "layout",
    loadingTemplate: "loading",
    notFoundTemplate: "notFound"
    waitOn: ->
        Meteor.subscribe "me"

Router.route '/',
    name: 'front'
    onBeforeAction: ->
        if(Meteor.user() || Meteor.loggingIn())
            this.redirect('/home')
        this.next()

Router.route '/home',
    name: 'home'
    waitOn: ->
        Meteor.subscribe "lists"

Router.route '/list/:_id',
    name: 'list'
    waitOn: ->
        Meteor.subscribe "list", this.params._id
    data: ->
        list: Lists.findOne this.params._id
        items: Items.find {
            listId: this.params._id
        }, {
            sort: [["checked","asc"],["priority","desc"],["created","asc"]]
        }
        users: Meteor.users.find()

requireLogin = ->
    if Meteor.loggingIn()
        this.render this.loadingTemplate
    else if not Meteor.userId()
        this.router.go('/')
    this.next()

Router.onBeforeAction requireLogin,
    except: ['/']
