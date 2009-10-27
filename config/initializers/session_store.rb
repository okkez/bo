# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bo_session',
  :secret      => 'a18258088f9c51553e99b2b47eed51a8e57c54207924aa32525096b8e159d76651a411a0dcea4a00bfe92c887cf42e75086a6989d4cd02168aa43c1fc0526f24'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
