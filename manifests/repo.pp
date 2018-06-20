# Wazuh App Copyright (C) 2018 Wazuh Inc. (License GPLv2)
# Repo installation
class wazuh::repo (
  $redhat_manage_epel = true,
) {

  case $::osfamily {
    'Redhat' : {
        case $::os[name] {
          /^(CentOS|RedHat|OracleLinux|Fedora|Amazon)$/: {
            if ( $::operatingsystemrelease =~ /^5.*/ ) {
              $baseurl  = 'https://packages.wazuh.com/3.x/yum/5/'
              $gpgkey   = 'http://packages.wazuh.com/key/GPG-KEY-WAZUH-5'
            } else {
              $baseurl  = 'https://packages.wazuh.com/3.x/yum/'
              $gpgkey   = 'https://packages.wazuh.com/key/GPG-KEY-WAZUH'
            }
          }
          default: { fail('This ossec module has not been tested on your ${::osfamily} distribution.') }
        }
      # Set up OSSEC repo
      yumrepo { 'wazuh':
        descr    => "WAZUH OSSEC Repository - www.wazuh.com",
        enabled  => true,
        gpgcheck => 1,
        gpgkey   => $gpgkey,
        baseurl  => $baseurl
      }

      if $redhat_manage_epel {
        # Set up EPEL repo
        # NOTE: This relies on the 'epel' module referenced in metadata.json
        package { 'inotify-tools':
          ensure  => present
        }
        include epel

        Class['epel'] -> Package['inotify-tools']
      }
    }
    default: { fail('OSFamily issue in [repo.pp] for Amazon Linux') }
  }
}
