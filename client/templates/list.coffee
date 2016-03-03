
Template.item.helpers
    checkedState: ->
        if this.checked
            "checked"
        else
            ""

Template.itemsList.events
    'submit #formAdd': (e) ->
        e.preventDefault()
        form = $ '#formAdd'
        text = form.find '[name=text]'
        if !text.val()
            return
        Meteor.call "addItem",
            this.list._id,
            text.val()
        text.val("")

Template.itemsList.onRendered ->
    this.find('.wrapper')._uihooks =
        insertElement: (node, next) ->
            $(node)
                .hide()
                .insertBefore(next)
                .fadeIn()
        removeElement: (node) ->
            $(node).animate({opacity: 0,marginLeft: "100px"}, ->
                el = $ this
                el.animate({marginTop: (-el.outerHeight(true))+"px"}, ->
                    el.remove()))

Template.item.events
    'click .removeItem': (e) ->
        Meteor.call "removeItem", this._id

    'click input': (e) ->
        state = e.currentTarget.checked
        Meteor.call "checkItem", this._id, state

    'click span.itemText': (e) ->
        inst = Template.instance()
        inst.$('.itemText').toggle()
        inst.$('input.itemText').focus()

    'blur input.itemText': (e) ->
        inst = Template.instance()
        inst.$('.itemText').toggle()
        text = inst.$('input.itemText')
        Meteor.call "changeItemText", this._id, text.val()

    'keypress input.itemText': (e) ->
        if e.which is 13 or e.keyCode is 13
            Template.instance().$('input.itemText').blur()

Template.list.events
    'submit #formGiveAccess': (e) ->
        e.preventDefault()
        form = $ '#formGiveAccess'
        username = form.find '[name=username]'
        if !username.val()
            return
        Meteor.call "giveAccess",
            this.list._id,
            username.val()
        username.val ""

Template.list.helpers
    'isCreator': ->
        this.list.creator is Meteor.userId()
