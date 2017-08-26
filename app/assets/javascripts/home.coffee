class ButtonForm
  constructor: (el, setting) ->
    @el = $(el)

  handleForm: (el) =>
    $(el).on 'ajax:success', (e, data, status, xhr) ->
      id = data.id
      if @.dataset.action  == 'reject'
        el = document.getElementById("appWaiting#{id}")
        $(el).detach()
      if @.dataset.action  == 'approve'
        html = App.utils.render('home/home_team', data)
        $("#userCollTeams").prepend(html)
        el = document.getElementById("appWaiting#{id}")
        $(el).detach()
    $(el).on 'ajax:error', (data, status, xhr) ->
      App.utils.errorMessage(I18n.t('error'))

this.App.buttonform = new ButtonForm()

$ ->
  dataContainer = $('#awaitingCollTeams')

  if $(dataContainer).length
    button = $('.js-coll')
    App.buttonform.handleForm(button)
