#
# Cookbook Name:: awesome_customers
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'awesome_customers::webserver'
include_recipe 'awesome_customers::database'
