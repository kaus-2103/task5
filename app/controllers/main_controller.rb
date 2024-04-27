class MainController < ApplicationController
  def index
    @user = User.all
    session[:i] ||= 0
  end

  def generate_fake_data
    seed = params[:seed].to_i || Random.new_seed
    region = params[:region] || 'en' 
    error_value = params[:error_value].to_f  

    session[:i] = 0 if params[:scroll] == 'false'

    puts ">>>>> params <<<<< #{params[:scroll]}"
    puts ">>>>> session <<<<< #{session[:i]}"
    puts ">>>>> error <<<<< #{error_value}"


    case region
    when 'Poland'
      Faker::Config.locale = 'pl'
    when 'USA'
      Faker::Config.locale = 'en-US'
    when 'UK'
      Faker::Config.locale = 'en-GB'
    else
      Faker::Config.locale = 'en'
    end

    num_user = params[:scroll] == 'true' ? 10 : 20
    puts ">>>>> number <<<<< #{num_user}"
    users = generate_fake_data_for_region(num_user, seed, error_value)

    render json: users
  end

  private

  def generate_fake_data_for_region(num_users, seed, error_value)
    faker_rand = Random.new(seed)
    Faker::UniqueGenerator.clear 
    Faker::Config.random = faker_rand 
    users = []

    num_users.times do
      if error_value != 0 && rand(0..10) <= error_value
        users << {
          id: session[:i] + 1,
          name: Faker::Lorem.word,  
          address: Faker::Lorem.sentence,  
          phone: Faker::Alphanumeric.alphanumeric,  
          identifier: Faker::Alphanumeric.alphanumeric(number: 10)
        }
      else
        users << {
          id: session[:i] + 1,
          name: Faker::Name.name,
          address: Faker::Address.full_address,
          phone: Faker::PhoneNumber.phone_number,
          identifier: Faker::Alphanumeric.alphanumeric(number: 10)
        }
      end      
      session[:i] += 1  
    end
    users
  end
end
