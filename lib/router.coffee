Router.configure
    layoutTemplate: "layout",
    loadingTemplate: "loading",
    notFoundTemplate: "notFound"

Router.route '/', name: 'main'

Router.route '/list/:_id',
    name: 'list'
    data: ->
        Lists.findOne(this.params._id)
