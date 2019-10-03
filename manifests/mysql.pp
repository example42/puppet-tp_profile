# tp_profile::mysql
#
# @summary This tp profile manages mysql with Tiny Puppet (tp)
#
# @example Just include it to install mysql
#   include tp_profile::mysql
#
# @example Include via psick module classification (yaml)
#   psick::profiles::linux_classes:
#     mysql: tp_profile::mysql
#
# @example To upstream repos instead of OS defaults (if tinydata available) as packages source:
#   tp_profile::mysql::upstream_repo: true
#
# @example Manage extra configs via hiera (yaml) with templates based on custom options
#   tp_profile::mysql::ensure: present
#   tp_profile::mysql::resources_hash:
#     tp::conf:
#       mysql:
#         epp: profile/mysql/mysql.conf.epp
#       mysql::dot.conf:
#         epp: profile/mysql/dot.conf.epp
#         base_dir: conf
#   tp_profile::mysql::options_hash:
#     key: value
#
# @example Enable default auto configuration, if configurations are available
#   for the underlying system and the given auto_conf value, they are
#   automatically added.
#   tp_profile::mysql::auto_conf: true
#
# @param manage If to actually manage any resource in this profile or not
# @param ensure If to install or remove mysql. Valid values are present, absent, latest
#   or any version string, matching the expected mysql package version.
# @param upstream_repo If to use mysql upstream repos as source for packages
#   or rely on default packages from the underlying OS
# @param resources_hash An hash of tp::conf and tp::dir resources for mysql.
#   tp::conf params: https://github.com/example42/puppet-tp/blob/master/manifests/conf.pp
#   tp::dir params: https://github.com/example42/puppet-tp/blob/master/manifests/dir.pp
# @param resources_auto_conf_hash The default resources hash if auto_conf is set.
#   The final resources managed are the ones specified here and in $resources_hash.
#   Check tp_profile::mysql::resources_auto_conf_hash in data/$auto_conf/*.yaml for
#   the auto_conf defaults.
# @param install_hash An hash of valid params to pass to tp::install defines. Useful to
#   manage specific params that are not automatically defined.
# @param options_hash An open hash of options to use in the templates referenced
#   in the tp::conf entries of the $resources_hash.
# @param options_auto_conf_hash The default options hash if auto_conf is set.
#   Check tp_profile::mysql::options_auto_conf_hash in data/$auto_conf/*.yaml for
#   the auto_conf defaults.
# @param settings_hash An hash of tp settings to override default mysql file
#   paths, package names, repo info and whatever can match Tp::Settings data type:
#   https://github.com/example42/puppet-tp/blob/master/types/settings.pp
# @param auto_prereq If to automatically install eventual dependencies for mysql.
#   Set to false if you have problems with duplicated resources, being sure that you
#   manage the prerequistes to install mysql (other packages, repos or tp installs).
# @param no_noop Set noop metaparameter to false to all the resources of this class. If set,
#   the trlinkin/noop module is required.
class tp_profile::mysql (
  Tp_Profile::Ensure $ensure                = 'present',
  Boolean         $manage                   = true,
  Hash            $resources_hash           = {},
  Hash            $resources_auto_conf_hash = {},
  Hash            $install_hash             = {},
  Hash            $options_hash             = {},
  Hash            $options_auto_conf_hash   = {},
  Hash            $settings_hash            = {},
  Optional[Boolean] $upstream_repo          = undef,
  Boolean         $auto_prereq              = true,
  Boolean         $no_noop                  = false,
) {

  if $manage {
    if $no_noop {
      info('Forced no-noop mode in tp_profile::mysql')
      noop(false)
    }
    $options_all = $options_auto_conf_hash + $options_hash
    $install_defaults = {
      ensure        => $ensure,
      options_hash  => $options_all,
      settings_hash => $settings_hash,
      auto_repo     => $auto_prereq,
      auto_prereq   => $auto_prereq,
      upstream_repo => $upstream_repo,
    }
    tp::install { 'mysql':
      * => $install_defaults + $install_hash,
    }

    # tp::conf iteration based on $resources_hash['tp::conf']
    $file_ensure = $ensure ? {
      'absent' => 'absent',
      default  => 'present',
    }
    $conf_defaults = {
      ensure        => $file_ensure,
      options_hash  => $options_all,
      settings_hash => $settings_hash,
    }
    $tp_confs = pick($resources_auto_conf_hash['tp::conf'], {}) + pick($resources_hash['tp::conf'], {})
    # All the tp::conf defines declared here
    $tp_confs.each | $k,$v | {
      tp::conf { $k:
        * => $conf_defaults + $v,
      }
    }

    # tp::dir iteration on $resources_hash['tp::dir']
    $dir_defaults = {
      ensure             => $file_ensure,
      settings_hash      => $settings_hash,
    }
    # All the tp::dir defines declared here
    $tp_dirs = pick($resources_auto_conf_hash['tp::dir'], {}) + pick($resources_hash['tp::dir'], {})
    $tp_dirs.each | $k,$v | {
      tp::dir { $k:
        * => $dir_defaults + $v,
      }
    }
  }
}
