# This class will install and configure chocolatey
# Chocolatey needs to be installed to work with the provider in this module
class chocolatey (
  $sources  = {},
  $features = {}
  ){
  $chocolatey_path = 'C:\ProgramData\chocolatey'

  # Will reinstall Chocolatey if the host is running the old Powershell-based version.
  exec { 
    'install-chocolatey':
      path     => $::path,
      provider => powershell,
      command  => 'iex ((new-object net.webclient).DownloadString(\'https://chocolatey.org/install.ps1\'))',
      unless   => "if (!(Test-Path ${chocolatey_path}) -or ((choco -v) -match '0.9.8')) { exit 1 } else { exit 0 }"
  } -> Package <| provider == chocolatey |>

  $default_features = {
    'checksum_files'            => true,
    'auto_uninstaller'          => false,
    'allow_global_confirmation' => false
  }
  $_features         = merge($default_features, $features)

  file {
    "${chocolatey_path}/config/chocolatey.config":
      ensure  => present,
      content => template('chocolatey/chocolatey.config.erb');
  }
}
