#!/usr/bin/perl -w
use strict;
use CGI qw/:standard/;
use DBI;
use CGI::Cookie;

my $login = param('login');
$login=~s/\s+//g;
my $password = param('password');
$password=~s/\s+//g;
my $session_type = param('session');
print "Session: $session_type\n";

my $dsn = "dbi:mysql:database=Quotations;host=localhost;port=3306";
my $dbh = DBI->connect($dsn, "root", "PerlStudent") or (print redirect(-uri=>'login.pl?result=fail&comment=Can not connect to database.') and die "SQL Error: $DBI::errstr\n");

my $sth = $dbh->prepare('SELECT * FROM users WHERE login = ?');
$sth->execute($login);

while (my $ans = $sth->fetchrow_hashref) {
    if($ans->{'login'} eq $login && $ans->{'password'} eq $password)
    {
    	my $id = $ans->{'id'};
    	$sth->finish;
    	$dbh->disconnect;
        my $cookie;
        if($session_type=~m/on/g)
        {
            $cookie = CGI::Cookie->new(-name=>'Login',-value=>$login,-expires=>'+1y',-domain=>'192.168.170.130');
        }
        else
        {
            $cookie = CGI::Cookie->new(-name=>'Login',-value=>$login,-domain=>'192.168.170.130');
        }
    	print redirect(-uri=>'index.pl', -cookie=>$cookie);
    }
    else
    {
    	$sth->finish;
    	$dbh->disconnect;
    	print redirect(-uri=>'login.pl?result=fail&comment=Username or password is wrong');
    }
}
$dbh->disconnect;
print redirect(-uri=>'login.pl?result=fail&comment=Username is not in base');