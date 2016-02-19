Router.configure
    layoutTemplate: "layout",
    loadingTemplate: "loading",
    notFoundTemplate: "notFound"

Router.route '/', name: 'main'

Router.route '/list/:_id',
    name: 'list'
    data: ->
        list: Lists.findOne this.params._id
        items: Items.find
            listId: this.params._id
