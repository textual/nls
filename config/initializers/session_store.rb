# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_v2_session',
  :secret      => 'd8d7af99fae2b860d02b9bdecc27b219d0edf7a9b7a1337f49d06ae943aa626453bc4ce3ac10a636831098e97323587187aba311b0efa1a8b04694725c4661eb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
