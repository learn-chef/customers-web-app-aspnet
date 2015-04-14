#
# Cookbook Name:: web_application
# Recipe:: database
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
directory 'C:\\temp'

template 'C:\\temp\\ConfigurationFile.ini' do
  source 'ConfigurationFile.ini.erb'
end

execute "mount share" do
    command "net use Y: \\\\WIN-EK7U4GHA88C\\Users\\Administrator\\Downloads /persistent:No"
    not_if "net use | findstr /i \"Y:\" "
end

windows_package "Microsoft SQL Server 2012 (64-bit)" do
  source 'Y:\\SQLEXPR_x64_ENU.exe'
  timeout 3600
  action :install
  installer_type :custom
  options "/Q /ConfigurationFile=C:\\temp\\ConfigurationFile.ini /UPDATEENABLED=False /IACCEPTSQLSERVERLICENSETERMS"
end

execute "unmount share" do
    command "net use Y: /delete /y"
    only_if "net use | findstr /i \"Y:\" "
end

template 'C:\\temp\\create-database.sql' do
  source 'create-database.sql.erb'
end

# Create the database and seed it with a table and test data.
execute 'initialize database' do
  command "sqlcmd -sMSSQLSERVER -i C:\\temp\\create-database.sql"
  only_if "sqlcmd -sMSSQLSERVER -Q \"SELECT COUNT(*) FROM (SELECT DB_ID('learnchef') AS DbID) t WHERE DbID IS NOT NULL\" | findstr 0"
end
