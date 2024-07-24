# Installing Packer
Refer to the packer documentation for installing the packer-cli based on your OS.

https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli#installing-packer

# packer-images

# Building the ubuntu packer image
```
    $ cd ./images/<folder>
    $ packer init .
    $ packer validate .
    $ packer build images.pkr.hcl
```

