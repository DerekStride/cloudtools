#!/usr/bin/env ruby

#-----------------------------------------------------------------------------#
# AWSTools - Local AWS Toolkit
# @author Derek Stride
#
# This script contains code that uses the aws-sdk gem to provision ec2
# instances.
#
# @version 0.1.0
# @date July 25th 2015
#
# Capabilities include
# => Creating VMs (EC2 Instances)
#
# Notes:
#
#-----------------------------------------------------------------------------#

require 'commander/import'
require 'aws-sdk'

@usage_prompt = 'FORMAT: awstools [command] [resource] [args]'

# Used For Following Example Logic
# var = alias[var] || var
# Short Circuit operator chooses the latter if the preceding fails
@resource_aliases = {
  'e'   => 'ec2',
  'vm'  => 'ec2',
  's3'  => 'bucket',
  'b'   => 'bucket'
}
@command_aliases = {
  'l'  => 'list',
  's'  => 'show',
  'd'  => 'delete',
  'c'  => 'create',
  'h' => '--help'
}

program :name, 'AWSTools'
program :version, '0.1.0'
program :description, 'Commandline Tool for Use with Amazon Web Services.'

ARGV << '--help' if ARGV.empty?

FREE_IMAGE_TIER = {
  rhel:   'ami-e7527ed7',
  ubuntu: 'ami-5189a661',
  amazon: 'ami-4dbf9e7d'
}

###############################################################################
#
# Lists
#
###############################################################################
command :create do |c|
  c.syntax = 'opentools list [resource]'
  c.summary = 'Create a new aws instance.'
  c.description = <<-EOF.gsub(/^\s+\|/, '')
    |Used to create new resources.
  EOF
  c.example 'You can specify a oneauth path instead of a user',
            'opentools list template ~/.one/oneauth thor'
  c.action do |_args, _options|
    client = get_client
    vm = Aws::EC2::Resource.new(client: client)
    ami = vm.image(FREE_IMAGE_TIER[:ubuntu])
    key_pair = vm.key_pair('cloudtools')
    instance_options = ec2_instance_options.merge(
          image_id: ami.image_id,
          key_name: key_pair.name
      )
    vm.create_instances(instance_options)
  end
end # End List

def get_client(region = 'us-west-2')
  Aws::EC2::Client.new(
      region: region
    )
end

def ec2_instance_options
  {
    min_count: 1, # required
    max_count: 1, # required
    security_group_ids: ['sg-e2e12b86'],
    instance_type: 't2.micro', # accepts t2.micro, t2.small, t2.medium, t2.large
    placement: { availability_zone: 'us-west-2b' },
    monitoring: { enabled: false }, # required
    instance_initiated_shutdown_behavior: 'terminate', # accepts stop, terminate
  }
end
