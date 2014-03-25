# This class will install and configure chocolatey
# Chocolatey needs to be installed to work with the provider in this module
class chocolatey { 
  exec { 
    'install-chocolatey':
      creates => 'C:\Chocolatey',
      path    => $::path,
      command => 'cmd.exe /K @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString(\'https://chocolatey.org/install.ps1\'))"'
  } -> Package <| provider == chocolatey |>
  
#  file {
#    'C:/Chocolatey/chocolatey.config':
#      ensure  => present,
#      content => template('chocolatey/chocolatey.config.erb');
#  }
}