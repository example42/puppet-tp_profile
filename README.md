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

This module provides a set of standard classes to handle different applications, on different Operating Systems, using Tiny Puppet defines.

## Setup

### What tp_profile affects 

When you include a tp profile the relevant application package and service are managed.

Via additional class parameters, which are the same for every tp profile class, you can manage:
- If to use the upstream application repos or the underlying OS ones to install the package
- The application's configuration files, in the shape, format and way you want

### Beginning with tp_profile

Just include and tp profile to install the relevant application. Handle via Hiera all your customisations

## Usage

To install mongodb, for example, just:

    include tp_profile::mongodb

Then you can configure the class parameters via Hiera (all the classes have the same parameters, so what's written here for mongodb applies to all the supported application):

To use mongodb upstream repos, rather than the default one of the underlying OS (note, this option works when it's present the relevant tinydata to manage upstream repos for a given app):

    tp_profile::mongodb::upstream_repo: true

## Limitations

## Development
