#
# Cookbook Name:: brightbox
# Recipe:: default
#
# Copyright 2013, Bubble
# Based on https://github.com/filtersquad/chef-brightbox
#
# The MIT License (MIT)
include_recipe "apt"
include_recipe "build-essential"

apt_repository "brightbox-ruby-ng-#{node['lsb']['codename']}" do
  uri          "http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu"
  distribution node['lsb']['codename']
  components   %w(main)
  keyserver    "keyserver.ubuntu.com"
  key          "C3173AA6"
  action       :add
  notifies     :run, "execute[apt-get update]", :immediately
end

cookbook_file "/root/.gemrc" do
  action :create_if_missing
  source "gemrc"
  mode   "0644"
end

packages = ["build-essential", "ruby#{node['brightbox']['version']}"]
packages << "ruby#{node['brightbox']['version']}-dev"
packages << "ruby-switch"
packages.each do |name|
  apt_package name do
    action :install
  end
end

execute "gem update --system" do
  environment "PATH" => "/usr/bin:$PATH"
end

gem_package "bundler" do
  gem_binary "/usr/bin/gem"
end
