
def fill_in_autocomplete(selector, value, value2, id)
  script = %Q{ $('#{selector}').val('#{value}').focus().keypress() }
  page.execute_script(script)
  page.execute_script("document.getElementById('#{id}').setAttribute('value', '#{value2}');")
end

def choose_autocomplete(text)
  expect(page).to have_css('.tt-suggestion', text: text, visible: false)
  script = %Q{ $('.tt-suggestion:contains("#{text}")').click() }
  page.execute_script(script)
end
