node default {
 include bash
  
 class { 'apache' :
   version => '2.2*',
   ensure => latest,
 }
 
 class { 'perl' :
   versions =>{
     perl => '5.10*',
     mod_perl => '*',
   },
   ensure => latest,
 }
}
