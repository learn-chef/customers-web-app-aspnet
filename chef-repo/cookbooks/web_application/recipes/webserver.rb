#
# Cookbook Name:: web_application
# Recipe:: webserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
# Install the Web Server role.
windows_feature 'IIS-WebServerRole' do
  action :install
end

# Install prerequisite features for IIS-ASPNET45.
%w(IIS-ISAPIFilter IIS-ISAPIExtensions NetFx3ServerFeatures NetFx4Extended-ASPNET45 IIS-NetFxExtensibility45).each do |f|
  windows_feature f do
    action :install
  end
end

# Install the ASP.NET module.
windows_feature 'IIS-ASPNET45' do
  action :install
end
