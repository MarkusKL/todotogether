
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
        moveElement: (node, next) ->
            $node = $ node
            $next = $ next
            oldTop = $node.offset().top
            height = $node.outerHeight(true)

            $inBetween = $next.nextUntil(node)
            if $node.index() < $next.index()
                $inBetween = $next.prevUntil(node)

            $node.insertBefore(next)
            newTop = $node.offset().top

            $node
                .removeClass('animate')
                .css('top', oldTop - newTop)

            $inBetween
                .removeClass('animate')
                .css('top', if oldTop < newTop then height else -1*height)

            $node.offset()

            $node.addClass('animate').css('top',0)
            $inBetween.addClass('animate').css('top',0)

        removeElement: (node) ->
            $node = $ node
            $node.removeClass("animate")
            $node.animate({opacity: 0,left: "50px"}, ->
                $node.animate({marginTop: (-$node.outerHeight(true))+"px"}, ->
                    $node.remove()))

Template.item.events
    'click .removeItem': (e) ->
        Meteor.call "removeItem", this._id

    'click input.checkInput': (e) ->
        state = e.currentTarget.checked
        Meteor.call "checkItem", this._id, state

    'blur input.itemText': (e) ->
        text = Template.instance().$('input.itemText')
        Meteor.call "changeItemText", this._id, text.val()

    'keypress input.itemText': (e) ->
        if e.which is 13 or e.keyCode is 13
            Template.instance().$('input.itemText').blur()

    'blur input.priorityInput': (e) ->
        priority = Template.instance().$('input.priorityInput');
        num = priority.val()
        if num
            num = Number(num)
            if isNaN(num)
                num = ""
        Meteor.call "setPriority", this._id, num, (err) ->
            if err
                priority.val(this.priority)

    'keypress input.priorityInput': (e) ->
        if e.which is 13 or e.keyCode is 13
            Template.instance().$('input.priorityInput').blur()

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

    'click .deleteListButton': (e) ->
        Meteor.call "deleteList", this.list._id
        Router.go('/') # Antipattern?

Template.accessList.helpers
    'isCreator': ->
        this.list.creator is Meteor.userId()

Template.userItem.onCreated ->
    this.subscribe "userInfo", this.data

Template.userItem.helpers
    'username': ->
        usr = Meteor.users.find(this.valueOf()).fetch()
        if usr.length > 0
            return usr[0].username
        return undefined

Template.userItem.events
    'click li': ->
        Meteor.call(
            "revokeAccess",
            Template.parentData().list._id,
            Template.currentData()
        )
