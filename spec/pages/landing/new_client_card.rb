# frozen-string-literal: true

class NewClientCard
  include Capybara::DSL

  def create_client(first_name, last_name)
    click_on(class: 'button-link button-navbar create')
    click_on('Create client')

    within(find('.prospective-client-ui')) do
      fill_in('firstName', with: first_name)
      fill_in('lastName', with: last_name)
      click_button('Continue')
    end
  end
end
