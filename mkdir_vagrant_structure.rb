# This ruby file creates a directory layout with pre-populated Vagrantfiles for Linux and BSD images.
# The goal is to make it easier to 'vagrant up' any particular image for testing.

# Modules
require 'fog'  # Interact with the Rackspace Cloud
require 'csv'  # Needed to parse the vagrant --machine-readable output
require 'json' # Needed to parse through the Fog::compute response
require 'fileutils' # Needed to be smarter about interacting with dirs

# Rackspace API variables are set as bash environment variables
RS_USER = ENV['RS_USER'] 
RS_KEY = ENV['RS_KEY'] 
RS_REGION = ENV['RS_REGION'] 
RS_NETWORK = ENV['RS_NETWORK'] 

# Setup the compute
service = Fog::Compute.new({
   :provider           => 'Rackspace', # Rackspace Fog Provider
   :rackspace_username => RS_USER,# Rackspace Username
   :rackspace_api_key  => RS_KEY, # Rackspace API Key
   :version            => 'v2', # Use Next Gen Cloud Servers
   :rackspace_region   => RS_REGION,# Datacenter
   :connection_options => {}
})

# Gather the list of images
response = service.list_images
image_list = response.body

# Setup the list of excludes
images_excluded = ['Windows','iPXE','Vyatta']
image_hash = Hash.new()
dirnames = Array.new()

# Going through all of the images and only print those not on the exclude list
image_list['images'].each do |image| 
   print_image = true # Set the default to be true, if it matches an excluded image, it will be set to false

   images_excluded.each do |exclude|
      if image['name'].include? exclude 
         print_image = false # Do not process this image
      end
   end

   if print_image 
      dirname = image['name'].downcase.tr(" ","_").tr("(","").tr(")","") # Created the directory by replacing spaces with _ and removing parenthesis
      imagename = image['name'].tr('(',".*").tr(')',".*") # Replace open/close parenthesis with . so the image name can be matched directly
      dirnames.push dirname

      # Note: I could not for the life of me figure out how to get a "\(" or "\)" to be printed on the damn screen.
      # I opted to just replace it with a . so that it maches any single character

      # Create the directories as needed
      FileUtils.mkdir_p dirname

      # Read in the template file
      tmp_file = File.read(File.expand_path('../Vagrantfile.template', __FILE__))

      # Write the Vagrantfile out in to the proper directory 
      File.open( dirname + '/Vagrantfile' , 'w') { |file| file.puts tmp_file.gsub(/--RS-IMAGE--/, imagename ).gsub(/--RS-SERVER--/ , dirname) }
   end
end

# Cleanup old unused directories
basedir = Dir.pwd

Dir.foreach(basedir) do |dir|
   # Ignore current and parent directorires, and any that we just created, or symlinks
   next if dir == '.' or dir == '..' or dir == '.git' or dirnames.include?(dir) or File.symlink?(dir) or File.file?(dir)

   print(dir)
   # cd into the vagrant machine directory and get it's status
   FileUtils.chdir dir
   csvoutput = CSV.parse `vagrant status --machine-readable 2>&1`

   # Get back to the parent directory so we can remove the dir if needed and continue
   FileUtils.chdir basedir
   if csvoutput[1][3] == 'not_created'
      FileUtils.rm_rf dir
   end
end
