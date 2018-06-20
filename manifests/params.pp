# Wazuh App Copyright (C) 2018 Wazuh Inc. (License GPLv2)
# Paramas file
class wazuh::params {
  case $::kernel {
    'Linux': {

      $config_file = '/var/ossec/etc/ossec.conf'
      $shared_agent_config_file = '/var/ossec/etc/shared/agent.conf'

      $config_mode = '0640'
      $config_owner = 'root'
      $config_group = 'ossec'

      $keys_file = '/var/ossec/etc/client.keys'
      $keys_mode = '0640'
      $keys_owner = 'root'
      $keys_group = 'ossec'

      $manage_firewall = false

      $authd_pass_file = '/var/ossec/etc/authd.pass'

      $validate_cmd_conf = '/var/ossec/bin/verify-agent-conf -f %'

      $processlist_file = '/var/ossec/bin/.process_list'
      $processlist_mode = '0640'
      $processlist_owner = 'root'
      $processlist_group = 'ossec'

      # this hash is currently only covering the basic config section of config.js
      # TODO: allow customization of the entire config.js
      # for reference: https://documentation.wazuh.com/current/user-manual/api/configuration.html
      $api_config_params = [
        {'name' => 'ossec_path', 'value' => '/var/ossec'},
        {'name' => 'host', 'value' => '0.0.0.0'},
        {'name' => 'port', 'value' => '55000'},
        {'name' => 'https', 'value' => 'no'},
        {'name' => 'basic_auth', 'value' => 'yes'},
        {'name' => 'BehindProxyServer', 'value' => 'no'},
      ]

      case $::osfamily {
        'RedHat': {

          $agent_service  = 'wazuh-agent'
          $agent_package  = 'wazuh-agent'
          $server_service = 'wazuh-manager'
          $server_package = 'wazuh-manager'
          $api_service = 'wazuh-api'
          $api_package = 'wazuh-api'
          $service_has_status  = true
          $ossec_service_provider = 'redhat'
          $api_service_provider = 'redhat'

          $default_local_files = {
            '/var/log/messages'         => 'syslog',
            '/var/log/secure'           => 'syslog',
            '/var/log/maillog'          => 'syslog',
            '/var/log/yum.log'          => 'syslog',
            '/var/log/httpd/access_log' => 'apache',
            '/var/log/httpd/error_log'  => 'apache'
          }
          case $::operatingsystem {
            'Amazon': {
              # Amazon is based on Centos-6 with some improvements
              # taken from RHEL-7 but uses SysV-Init, not Systemd.
              # Probably best to leave this undef until we can
              # write/find a release-specific file.
              $wodle_openscap_content = undef
           }
            default: {
              fail('This ossec module has not been tested on Amazon Linux') 
            }
          }
        }
        default: { fail('This ossec module has not been tested on the Redhat Family') }
      }
    }
    
  default: { fail('This ossec module has not been tested on your Linux Kernel') }
  }
}
