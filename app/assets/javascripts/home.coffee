class ButtonForm
  constructor: (el, setting) ->
    @el = $(el)

  handleForm: (el) =>
    $(el).on 'ajax:success', (data, status, xhr) ->
      id = data.detail[0].id
      if @.dataset.action  == 'reject'
        el = document.getElementById("appWaiting#{id}")
        $(el).detach()
      if @.dataset.action  == 'approve'
        data = data.detail[0]
        html = App.utils.render('home/home_team', data)
        $("#userCollTeams").prepend(html)
        el = document.getElementById("appWaiting#{id}")
        $(el).detach()
    $(el).on 'ajax:error', (data, status, xhr) ->
      App.utils.errorMessage('Error')

this.App.buttonform = new ButtonForm()

$ ->
  dataContainer = $('#awaitingCollTeams')

  if $(dataContainer).length
    button = $('.js-coll')
    App.buttonform.handleForm(button)
