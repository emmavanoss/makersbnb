require 'sinatra/base'

require_relative 'model/listings.rb'
require_relative 'model/bookings.rb'
require_relative 'model/guest.rb'
require_relative 'model/landlord.rb'


class Bnb < Sinatra::Base

  DataMapper.setup :default, "postgres://#{ENV["USER"]}@localhost/makersbnb"
  DataMapper.finalize
  DataMapper.auto_migrate!

  get '/' do
    erb :index
  end

  get '/spaces' do
    @listings = Listing.all
    erb :spaces
  end

  get '/spaces/new' do
    erb :new_space
  end

  get '/guest/register' do 
    erb :guests_register
  end 

  post '/guest/registered' do 
    Guest.create(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email_address: params[:email_address],
      user_name: params[:user_name],
      password: params[:password]
    )
    redirect('/guest/ThankYou')
  end 

  get '/guest/ThankYou' do
        "Thank you for Signing Up :)"
  end 

  get '/landlord/register' do
    erb :landlord_register
  end 

  post '/landlord/registered' do
    Landlord.create(
    first_name: params[:first_name],
      last_name: params[:last_name],
      email_address: params[:email_address],
      user_name: params[:user_name],
      password: params[:password]
    )
    redirect ('/landlord/welcome')
  end

  get '/landlord/view' do
    @landlord = Landlord.get(1) # landlord with id 1
    erb :landlord_view
  end

  get '/landlord/welcome' do
    erb :landlord_welcome
  end 

  post '/listed' do
    Listing.create(
      location: params[:location],
      price: params[:price_per_night],
      dates_available: params[:dates_available],
      owner_name: params[:owner_name],
      contact_details: params[:contact_details],
      description: params[:description]
    )
    redirect('/spaces')
  end

  post '/booking' do
    Booking.create(
      check_in: params[:check_in],
      check_out: params[:check_out],
      listing_id: params[:listing_id]
    )
    redirect('/confirmation') 
  end

  get '/confirmation' do
    'Thanks for booking'
  end



  run! if app_file == $0
end
