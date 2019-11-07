#!/bin/bash

yum install -y wget
wget --content-disposition 'https://pm.puppet.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=latest'
tar -xzf puppet-enterprise-2019.2.0-el-7-x86_64.tar.gz

echo "1" | ./puppet-enterprise-2019.2.0-el-7-x86_64/puppet-enterprise-installer
