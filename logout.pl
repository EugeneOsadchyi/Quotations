#!/usr/bin/perl -w

use CGI qw/:standard/;
use CGI::Cookie;

my $login = param('Login');

$cookie = CGI::Cookie->new(-name=>'Login',-value=>$login,-expires=>'-1d',-domain=>'192.168.170.130');
print redirect(-uri=>'login.pl', -cookie=>$cookie);