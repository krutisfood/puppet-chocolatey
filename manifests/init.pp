# This class will install and configure chocolatey
# Chocolatey needs to be installed to work with the provider in this module
class chocolatey (
  $sources = { 'chocolatey' => 'https://chocolatey.org/api/v2/' }
  ){

  $chocolatey_path = 'C:/ProgramData/chocolatey'

  File {
    source_permissions => 'ignore',
    ensure             => 'present'
  }

  file { 'C:/temp/install.ps1':
    source => 'puppet:///modules/chocolatey/install.ps1',
  }

  file { "${chocolatey_path}/chocolateyinstall/chocolatey.config":
    content => template('chocolatey/chocolatey.config.erb'),
  }

  exec { 
    'install-chocolatey':
      creates => $chocolatey_path,
      path    => $::path,
      command => 'cmd.exe /K @powershell -NoProfile -ExecutionPolicy unrestricted -Command "C:\temp\install.ps1"',
      require => File['C:/temp/install.ps1'],
  } -> Package <| provider == chocolatey |>
}