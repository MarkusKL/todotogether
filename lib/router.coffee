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
    name: 'overview'

Router.route '/list/:_id',
    name: 'panelList'
    data: ->
        listId: this.params._id
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
