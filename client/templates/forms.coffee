
Template.formLogin.events
    'submit #formLogin': (e) ->
        e.preventDefault()
        form = $ '#formLogin'
        username = form.find('[name=username]').val()
        password = form.find('[name=password]').val()
        mode = form.find('[name=mode]').val()

        if mode is "login"
            Meteor.loginWithPassword username, password, (err) ->
                if err
                    Errors.show("Forkert brugernavn eller kodeord")
        else
            passwordConf = form.find('[name=passwordConfirm]').val()
            if passwordConf isnt password
                Errors.show("Der står ikke det samme i kodeords felterne")
                return
            Accounts.createUser {
                username: username
                password: password
            }, (err) ->
                if err
                    if err.error is 400
                        Errors.show("Udfyld alle felterne")
                    else
                        Errors.show("Det har vi allerede en der hedder")

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

Template.formLogout.events
    'click .buttonLogout': (e) ->
        e.preventDefault()
        Meteor.logout()
