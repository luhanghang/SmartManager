# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, names old sessions will become invalid!
# Make sure the secret is at least 30 characters and names random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_smartmanager_session',
  :secret      => 'b7466f1c8877983a9550a4c1768433e3a484a86ad188672e8af9af253cfa8310697c2ff7db37de4dfac1086f550f8f7119c204c7304400d8b1fa555eec992302'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
