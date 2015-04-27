# This class will install and configure chocolatey
# Chocolatey needs to be installed to work with the provider in this module
class chocolatey (
  $sources = { 'chocolatey' => 'https://chocolatey.org/api/v2/' }
  ){

  file { 'C:/temp/install.ps1':
    ensure             => present,
    source             => 'puppet:///modules/chocolatey/install.ps1',
    source_permissions => 'ignore',
  }

  file { 'C:/temp/set-sources.ps1':
    ensure             => present,
    content            => template('chocolatey/set-sources.ps1.erb'),
    source_permissions => 'ignore',
  }

  exec { 
    'install-chocolatey':
      creates => 'C:/ProgramData/Chocolatey',
      path    => $::path,
      command => 'cmd.exe /K @powershell -NoProfile -ExecutionPolicy unrestricted -Command "C:\temp\install.ps1"',
      require => File['C:/temp/install.ps1'],
      notify  => Exec['set-sources']
  }

  exec {
    'set-sources':
      path        => $::path,
      command     => "C:/temp/set-sources.ps1",
      refreshonly => true,
      require     => File['C:/temp/set-sources.ps1']
  } -> Package <| provider == chocolatey |>

}