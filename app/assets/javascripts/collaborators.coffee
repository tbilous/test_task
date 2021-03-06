# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  if $('#teamMembers').length
    current_locale = I18n.locale
    searchSelector = 'input.typeahead'
    thisForm = $(searchSelector).closest('form')
    target = thisForm.data('team')
    thisTable = '#awaitingTeamMembers'
    bloodhound = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('text'),
      queryTokenizer: Bloodhound.tokenizers.whitespace

      remote: {
        language: current_locale
        url: "/teams/#{target}/collaborators/staff.json?q=%QUERY",
        wildcard: "%QUERY",
        filter: (bloodhound) ->
          $.map bloodhound, (el) ->
            {
              text: "#{el.use_name}, #{el.email}" #text for DROPDOWN
              id: el.id
            }
      }
    )

    bloodhound.initialize()

    $(searchSelector).typeahead {
      highlight: true
      minLength: 1
    },
      limit: 5
      name: 'name-dataset'
      displayKey: 'text'
      source: bloodhound.ttAdapter()
    $(searchSelector).on 'typeahead:selected', (e, data) ->
      $('#collaborator_user_id').val(data.id)
      return

    $(thisForm).on 'ajax:success', (e, data, status, xhr) ->
      user = data.user
      $("#{thisTable} tr:last").after("<tr><td>#{user.use_name}</td><td>#{user.email}</td></tr>");
      $("#{thisTable} tr.js-detach").detach()
      $(searchSelector).typeahead('val', '')
      message = I18n.t('collaborator.send_success')
      App.utils.successMessage(message)
    $(document).on 'ajax:error', thisForm, (e, data, status, xhr) ->
      App.utils.errorMessage('Error')
