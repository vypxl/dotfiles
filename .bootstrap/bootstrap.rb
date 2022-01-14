#! /usr/bin/env ruby

Signal.trap("INT") { exit }
Signal.trap("TERM") { exit }

# Install packages
require './packages'
install_packages

# Set shell

# `chsh ...`
