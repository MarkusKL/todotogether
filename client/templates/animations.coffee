
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
            $node.animate({marginBottom: (-$node.outerHeight(true))+"px"}, ->
                $node.remove())
