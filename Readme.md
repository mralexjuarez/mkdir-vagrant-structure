# How to Setup Vagrant with Rackspace Cloud

## So what's Up with This Project?

This project was created to make it easier to test various cloud instances. I'm a fan of Vagrant and wanted to learn a little Ruby.

I mainly use this project as the basis for Linux training. Being able to quickly spin up different flavors lets me quickly run labs, and show general differences between Linux distributions.

Following this tutorial should get you up and running on a RHEL/CentOS or Ubuntu machine. OSX needs very little extra to setup. 

Note: I am NOT a Ruby programmer. This could be heavily improved on I'm sure. Any help would be greatly appreciated.

## Mise En Place (Getting Everything You Need in Place)
Depending on our host system, there may be a few things we need to get setup before we can get started. 

For all systems we need to make sure some Vagrant prerequisites are setup.

## Vagrant

First of we need Vagrant installed. You can download the release appropriate for your OS on their site.

https://www.vagrantup.com/

##### Vagrant Rackspace Plugin

When we want to launch servers in the Rackspace cloud we need to use the Rackspace vagrant provider. We install the provider via a plugin as seen below

    # vagrant plugin install vagrant-rackspace

##### Vagrant Rackspace Cloud Box

Every provider in Vagrant needs a default box (image). In this case it is a very small box containing only some meta information. We are going to name our box *rscloud*.

    # vagrant box add rscloud https://github.com/mitchellh/vagrant-rackspace/raw/master/dummy.box

## Linux Prerequisites

These are the general dependencies for most machines. There is an OS specific install line below.

- Ruby
- Ruby Development Libraries
- Ruby Gems
- gcc
- libxml2-devel
- libxslt-devel
- ImageMagick-devel (Still not sure where this one is coming from)

##### RHEL/CentOS

    # sudo yum -y install ruby ruby-devel rubygems gcc libxml2-devel libxslt-devel ImageMagick-devel
    

##### Ubuntu/Debian

    # apt-get install ruby ruby-dev gcc libxml2-dev libxslt1-dev graphicsmagick-libmagick-dev-compat libmagick++-dev git --no-install-recommends

*Note: The --no-install-recommends is added here because it saves about 40MB of space.*
 
## Project Repo

Lastly we will need the Git repository
https://github.com/mralexjuarez/mkdir-vagrant-structure

## Setup and Usage

The first step thing we need to do is install bundler to handle the ruby dependencies.

    # gem install bundler
Next we need to setup some environment variables by appending them to our *~/.bashrc* file.

```
# Rackspace Cloud API variables
export RS_USER=RACKSPACE_USERNAME
export RS_KEY=API_KEY
export RS_REGION=REGION
export RS_NETWORK=NETWORK_ID_IF_YOU_WANT_ONE
export PRIVATE_KEY=PATH_TO_PRIVATE_KEY
export PUBLIC_KEY=PATH_TO_PUBLIC_KEY
```
Because we just added these lines we will want to re-source our *bashrc* file. This will re-read the *bashrc* file and add our new variables.

    # source ~/.bashrc
Our next step is to download all of our Ruby dependencies.  Primarily this is the Fog gem as it is what the code uses to talk to the Rackspace Cloud API

    # bundle install
*In some cases I had to run bundle install with sudo due to permissions issues.*
Finally we create our directory structure

    # ruby mkdir_vagrant_structure.rb

The resulting directory listing should look like this.

```
[vagrant@centos7 mkdir-vagrant-structure]$ ls
arch_linux_pvhvm                  onmetal_-_fedora_22
centos_5_pv                       onmetal_-_fedora_23
centos_6_pv                       onmetal_-_ubuntu_14.04_lts_trusty_tahr
centos_6_pvhvm                    onmetal_-_ubuntu_15.10_wily
centos_7_pvhvm                    onmetal_v1_-_coreos_alpha
centos_7_pvhvm_orchestration      onmetal_v1_-_coreos_beta
coreos_alpha                      onmetal_v1_-_coreos_stable
coreos_beta                       onmetal_v1_-_debian_7_wheezy
coreos_stable                     onmetal_v1_-_ubuntu_12.04_lts_precise_pangolin
debian_7_wheezy_pvhvm             opensuse_13.2_pvhvm
debian_8_jessie_pvhvm             Readme.md
debian_testing_stretch_pvhvm      red_hat_enterprise_linux_5_pv
debian_unstable_sid_pvhvm         red_hat_enterprise_linux_6_pv
dfwimage-transfered               red_hat_enterprise_linux_6_pvhvm
dfwimage-transferedv2             red_hat_enterprise_linux_7_pvhvm
fedora_23_pvhvm                   rhcs_node_6.5
fedora_24_pvhvm                   rhcs_node_7
freebsd_10_pvhvm                  scientific_linux_6_pvhvm
Gemfile                           scientific_linux_7_pvhvm
Gemfile.lock                      ubuntu_12.04_lts_precise_pangolin_pv
gentoo_15.3_pvhvm                 ubuntu_12.04_lts_precise_pangolin_pvhvm
mkdir_vagrant_structure.rb        ubuntu_14.04_lts_trusty_tahr_pv
onmetal_-_centos_6                ubuntu_14.04_lts_trusty_tahr_pvhvm
onmetal_-_centos_7                ubuntu_14.04_lts_trusty_tahr_pvhvm_orchestration
onmetal_-_debian_8_jessie         ubuntu_16.04_lts_xenial_xerus_pvhvm
onmetal_-_debian_testing_stretch  Vagrantfile.template
onmetal_-_debian_unstable_sid
```

From this point our normal Vagrant work flow takes over.

Go into any directory

Bring the machine up
```
# vagrant up
```
SSH into the machine
```
# vagrant ssh
```
Once we are done testing

    # vagrant destroy

## Thank You!
