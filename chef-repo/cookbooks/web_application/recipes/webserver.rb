#
# Cookbook Name:: web_application
# Recipe:: webserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
# Install the Web Server role.
windows_feature 'IIS-WebServerRole' do
  action :install
end

# Install pre-requisite features for IIS-ASPNET45.
%w{IIS-ISAPIFilter IIS-ISAPIExtensions NetFx3ServerFeatures NetFx4Extended-ASPNET45 IIS-NetFxExtensibility45}.each do |f|
  windows_feature f do
    action :install
  end
end

# Install the ASP.NET module.
windows_feature 'IIS-ASPNET45' do
  action :install
end

include_recipe "iis::remove_default_site"

windows_zipfile "#{ENV['SYSTEMDRIVE']}\\inetpub\\apps\\Customers" do
  source 'https://github.com/learnchef/manage-a-web-app-windows/releases/download/v0.1.0/Customers.zip'
  action :unzip
  not_if {::File.exists?(::File.join("#{ENV['SYSTEMDRIVE']}\\inetpub\\apps", "Customers"))}
end

%w{bin}.each do |d|
  directory win_friendly_path(::File.join("#{ENV['SYSTEMDRIVE']}\\inetpub\\apps", 'Customers', d)) do
    rights :modify, 'IIS_IUSRS'
  end
end

%w{Web.config}.each do |f|
  file win_friendly_path(::File.join("#{ENV['SYSTEMDRIVE']}\\inetpub\\apps", 'Customers', f)) do
    rights :modify, 'IIS_IUSRS'
  end
end

iis_pool 'Products' do
  runtime_version "4.0"
  action :add
end

directory "#{ENV['SYSTEMDRIVE']}\\inetpub\\sites\\Customers" do
  rights :read, 'IIS_IUSRS'
  recursive true
  action :create
end

iis_site 'Customers' do
  protocol :http
  port 80
  path "#{ENV['SYSTEMDRIVE']}\\inetpub\\sites\\Customers"
  application_pool 'Products'
  action [:add,:start]
end

iis_app 'Customers' do
  application_pool 'Products'
  path '/Products'
  physical_path "#{ENV['SYSTEMDRIVE']}\\inetpub\\apps\\Customers"
  action :add
end
