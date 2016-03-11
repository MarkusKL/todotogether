
insert = (node, next) ->
    $(node)
        .insertBefore(next)
        .css('margin-bottom',(-$(node).outerHeight(true))+"px")
        .animate({marginBottom: 0})


move = (node, next) ->
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

remove = (node) ->
    $(node).animate({marginBottom: (-$(node).outerHeight(true))+"px"}, ->
        $(this).remove())

Template.itemsList.onRendered ->
    this.find('.wrapper')._uihooks =
        insertElement: insert
        moveElement: move
        removeElement: remove

Template.panelItemCollection.onRendered ->
    this.find('.wrapper')._uihooks =
        insertElement: insert
        moveElement: move
        removeElement: remove

Template.panelListsListBody.onRendered ->
    this.find('.wrapper')._uihooks =
        insertElement: insert
        moveElement: move
        removeElement: remove
