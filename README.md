**Short Description**

This repository contains the POC version of Trade Classifier. The project is build with CAP framework and have the multitenacy feature implemented. Also, different security aspects, the approuter and OData services implementation

**Deploy in SAP Cloud Platform trial one time**
login in your CF subaccount
create an instance of SAP HANA Cloud DB with the option allow all IP address
go in all application root folders and run the comand npm install
build the mta project
deploy the mta archive

**Important configuration in your subbacount**
It is very important to thave the following things:
  1) org name should be equal with subdomain. Also, don`t use spaces, special characters or uppercase
  2) space name should NOT contain spaces, special characters or uppercase
