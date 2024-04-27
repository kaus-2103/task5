class MainController < ApplicationController
  def index
    @user = User.all
    session[:i] ||= 0
  end

  def generate_fake_data
    session[:i] ||= 0
    seed = params[:seed].to_i || Random.new_seed
    region = params[:region] || 'en' 

    case region
    when 'Poland'
      Faker::Config.locale = 'pl'
    when 'USA'
      Faker::Config.locale = 'en-US'
    when 'UK'
      Faker::Config.locale = 'en-UK'
    else
      Faker::Config.locale = 'en'
    end

    users = generate_fake_data_for_region(20, seed)

    session[:i] += 0

    render json: users
  end

  private

  def generate_fake_data_for_region(num_users, seed)
    faker_rand = Random.new(seed)
    Faker::UniqueGenerator.clear 
    Faker::Config.random = faker_rand 
    users = []
    (session[:i]...session[:i] + num_users).each do |index|
      users << {
        id: index + 1,
        name: Faker::Name.name,
        address: Faker::Address.full_address,
        phone: Faker::PhoneNumber.phone_number,
        identifier: Faker::Alphanumeric.alphanumeric(number: 10) 
      }
    end
    users
  end
end
