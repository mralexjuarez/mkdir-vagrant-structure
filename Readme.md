### mkdir-vagrant-structure ###

#### The Why ####

I am a fan of Vagrant and using it to provision Rackspace Cloud servers.  I use it as a quick way to spin up servers when I just need to try something out.

I found myself always having to copy and re-edit a Vagrantfile if I wanted spin up a new instance. So I made it easier for myself.

#### How to Use It ####

Overall it should be easy enough to use this little script. It makes a small assumption that the rax\_cred\_file is in your home directory and the Vagrant.template file is in the same directory as the script.

In short, this script goes through all of the images in the Rackspace Cloud, and creates a local directory and a Vagrantfile for each image. It excludes a few images such as the Windows ones.

    # ruby ./mkdir\_vagrant_structure.rb
    
    ./arch_2014.5_pvhvm:
    Vagrantfile

    ./centos_5.10:
    Vagrantfile

    ./centos_6.5:
    Vagrantfile

    ./centos_6.5_pvhvm:
    Vagrantfile
    

#### General Notes ####

1. Tested with Ruby 2.1.2 so far.
2. I am not a Ruby programmer, so any suggestions on improving the script or proper formatting would be greatly appreciated.
3. 3. The Vagrantfile assuems the box has been added with the name "rscloud".  The box can be added via the following command.


    vagrant box add rscloud https://github.com/mitchellh/vagrant-rackspace/raw/master/dummy.box
