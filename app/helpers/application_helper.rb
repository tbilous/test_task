module ApplicationHelper
  def bootstrap_class_for(flash_type)
    hash = HashWithIndifferentAccess.new(success: ' alert-success',
                                         error: ' alert-warning',
                                         alert: ' alert-danger',
                                         notice: ' alert-info')
    hash[flash_type] || flash_type.to_s
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in helper-class") do
        concat content_tag(:button, '×', class: 'close', data: { dismiss: 'alert' })
        concat message.humanize
      end)
    end
    nil
  end

  def shallow_resource(*args)
    if args.last.persisted?
      args.last
    else
      args
    end
  end

  def render_flash
    javascript_tag('App.flash = JSON.parse(' "'#{j({ success: flash.notice, error: flash.alert }.to_json)}'" ');')
  end

  def render_errors_for(resource)
    return unless resource.errors.any?
    flash.now.alert = resource.errors.full_messages.join(', ')
  end

  def resource_present?(resource, val)
    resource.omniauth_providers.select { |c| c.to_s == val }.present?
  end

  def search_title(subject)
    subject.destination + ': ' + subject.checkin + ' - ' + subject.checkout
  end

  # rubocop:disable Style/GuardClause
  def errors_for(object)
    if object.errors.any?
      content_tag(:div, class: 'alert alert-danger') do
        concat content_tag(:button, '×', class: 'close', data: { dismiss: 'alert' })
        object.errors.full_messages.each do |msg|
          concat content_tag(:div, msg)
        end
      end
    end
  end

  def nav_bar
    content_tag(:ul, class: 'nav navbar-nav') do
      yield
    end
  end

  def nav_inline
    content_tag(:ul, class: 'list-inline nav-inline') do
      yield
    end
  end

  def nav_link(text, path)
    options = current_page?(path) ? { class: 'active' } : {}
    content_tag(:li, options) do
      link_to text, path
    end
  end

  def aside_link(path)
    content_tag(:li,
                class: "text-capitalize #{current_page?(path) ? 'active' : ''}") do
      link_to path do
        yield
      end
    end
  end

  def options_for_lang
    I18n.available_locales.map do |locale|
      locale = locale.to_s
      [I18n.t("locales.#{locale}"), locale]
    end
  end

  def transparentize
    %I(new_user_session new_user_password new_user_registration new_user_confirmation new_advertisers)
      .map { |i| current_page?(i) ? 'transparent-body' : '' }.join
  end
end
