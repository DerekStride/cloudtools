# CloudTools

CloudTools is a command-line utility to allow you to manage and view nodes in various cloud services built on their APIs. It depends on commander and has some pretty nice help information build into it.

## The Initial setup

### Mac

```bash
git clone https://github.com/DerekStride/cloudtools.git
bundle install
```

```bash
sudo ln -s /opt/cloudtools/awstools.rb /usr/local/bin/awstools
```

## Updating

```bash
sudo git -C /opt/cloudtools pull origin master 
```

## Use

If set up correctly typing awstools in your home directory should output the help menu.


### Create

* create vm [user]


## Examples

```bash
awstools --help
awstools help create
```
