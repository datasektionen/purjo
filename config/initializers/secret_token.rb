# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Rails.application.config.secret_token = ENV["SECRET_TOKEN"] ||
  '8f53924a27ba15125e9242cea92fe326d4c31fe1ec80550836290a364a6004032efcd3566270aadf9b8b20a3e9d9e86a934ec09bbce560153503051bd38f425a'
