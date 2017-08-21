# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  if $('#teamTasks').length
    button = $('.js-task-assign')
    console.log 'start'

    $(button).on 'ajax:success', (data, status, xhr) ->
      $(@).closest('td').html(I18n.t('task.actions.assigned'))

    $(button).on 'ajax:error', (data, status, xhr) ->
      App.utils.errorMessage(I18n.t('task.unknown_state'))
