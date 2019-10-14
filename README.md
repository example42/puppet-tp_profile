# tp_profile

This module provides classes to install different applications via Tiny Puppet (tp).

[![Build Status](https://travis-ci.org/example42/puppet-tp_profile.svg?branch=master)](https://travis-ci.org/example42/puppet-tp_profile)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with tp_profile](#setup)
    * [What tp_profile affects](#what-tp_profile-affects)
    * [Beginning with tp_profile](#beginning-with-tp_profile)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)

## Description

This module provides a set of standard classes to handle different applications, on different Operating Systems, using Tiny Puppet defines. These classes are automatically generated, using the commands in the `scripts` directory, and share a common set of parameters and the same functionality

## Setup

### What tp_profile affects 

When you include a tp profile the relevant application package(s) and service(s) are managed.

Via additional class parameters you can manage:
- If to use the upstream application repos or the underlying OS ones to install the package (relevant tinydata must be present)
- The application's configuration files, in the shape, format and way you want
- Whole directories related to the applications. Source of these dirs can be a Puppet fileserver source or a vcsrepo.

### Beginning with tp_profile

Just include and tp profile to install the relevant application. Handle via Hiera all your customisations

## Usage

To install mongodb, for example, just:

    include tp_profile::mongodb

Then you can configure the class parameters via Hiera (all the classes have the same parameters, so what's written here for mongodb applies to all the supported application):

To use mongodb upstream repos, rather than the default one of the underlying OS (note, this option works when it's present the relevant tinydata to manage upstream repos for a given app):

    tp_profile::mongodb::upstream_repo: true

To include the class but actually don't manage any of its resources:

    tp_profile::mongodb::manage: false

To remove the resources previously installed via the same profile (note this is different than manage option, here resources are actually managed, and removed):

    tp_profile::mongodb::ensure: absent

To customise the tp::install options of the relevant application:

    tp_profile::mongodb::install_options:
      cli_enable: true
      test_enable: true

To override tinydata settings:

    tp_profile::mongodb::settings_hash:
      package_name: my_mongo

To define the configuration files and dirs to manage:

    tp_profile::apache::resources_hash:
      tp::conf:                                   # Here an hash of tp::conf resources
        apache::openkills.info.conf:              # This refers to an apache configuration file called openkills.info.conf
          base_dir: conf                          # and placed in the conf.d dir
          template: psick/apache/vhost.conf.erb   # It uses the template apache/vhost.conf.erb in the psick module
          options_hash:                           # where are used the following variables
              ServerName: openskills.info
              ServerAlias:
              - openskill.info
              - www.openskills.info
              - www.openskill.info
              AddDefaultCharset: ISO-8859-1
        apache::deny_git.conf:                    # This is another configuration file, called deny_git.conf
          base_dir: conf                          # This is placed, as well, in the apache conf.d dir
          source: puppet:///modules/psick/apache/deny_git.conf # Its source is from the psick module as well
       tp::dir:                                   # Here we have an hash of tp::dir resources
        apache::openskills.info:                  
          vcsrepo: git                            # We expect the source to be a git repo
          source: git@bitbucket.org:alvagante/openskills.info.git # This is the source git repo
          path: /var/www/html/openskills.info     # This is the actual path of the directory
          ensure: latest                          # This ensures that  whenever Pupept runs, it syncs to upstream master on the git repo (Continuous Delivery done easy)

By default a tp profile automatically manages any resource needed to install the relevant application (package repos, other packages of tp installs). In case of duplicated resources or if you want to manage such resources by yourself, you can disable any form of automatic dependencies management with:

    tp_profile::mongodb::auto_prereq: flase

## Limitations

TP profiles are just classes that act as entrypoint for Hiera data that allows you to manage any applciation which tp can manage. They just handle package and service resources, in tp::install, and file resources, in tp::conf.

No other application specific resource is handled by these classes, and, unless you use the auto_conf settings, you are in full control of the configuration files to manage: you must know how to configure the applications you install via tp profiles.

## Development

Don't find the app you need among the tp_profiles? Let us know, we will add the relevant tinydata and generate a profile for it.

Have found issues, bugs or anything to fix? Open a ticket or submit a Pull Request.

Do you have any feature request? Open a ticket.
