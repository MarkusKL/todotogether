
Template.login.events
    'submit #formLogin': (e) ->
        e.preventDefault()
        form = $ '#formLogin'
        username = form.find('[name=username]').val()
        password = form.find('[name=password]').val()
        mode = form.find('[name=mode]').val()

        if mode is "login"
            Meteor.loginWithPassword username, password
        else
            passwordConf = form.find('[name=passwordConfirm]').val()
            if passwordConf isnt password
                return
            Accounts.createUser
                username: username
                password: password

    'click .buttonCreateMode': (e) ->
        e.preventDefault()
        form = $ '#formLogin'
        form.find('.modeLoginOnly').hide()
        form.find('.modeCreateOnly').fadeIn()
        form.find('[name=mode]').val("create")

    'click .buttonCancel': (e) ->
        e.preventDefault()
        form = $ '#formLogin'
        form.find('.modeCreateOnly').hide()
        form.find('.modeLoginOnly').fadeIn()
        form.find('[name=mode]').val("login")

Template.logout.events
    'click .buttonLogout': (e) ->
        e.preventDefault()
        Meteor.logout()
