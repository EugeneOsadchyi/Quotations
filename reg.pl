#!/usr/bin/perl -w
use strict;
use CGI;
use DBI;

my $cgi = CGI->new();

my $login = $cgi->param('login');
$login=~s/\s+//g;
my $password = $cgi->param('password');
$password=~s/\s+//g;

my $dsn = "dbi:mysql:database=Quotations;host=localhost;port=3306";
my $dbh = DBI->connect($dsn, "root", "PerlStudent") or (print $cgi->redirect('registration.pl?result=fail&comment=Can not connect to database.') and die "SQL Error: $DBI::errstr\n");

my $sth = $dbh->prepare('SELECT * FROM users WHERE login = ?');
$sth->execute($login);

while (my $ans = $sth->fetchrow_hashref) {
    if($ans->{'login'})
    {
    	$sth->finish;
    	$dbh->disconnect;
    	print $cgi->redirect('registration.pl?result=fail&comment=User ' . $login . ' already registered') and die;

    }
}

$dbh->do("insert into users (login, password) values (?,?)", {}, $login, $password) or (print $cgi->redirect('registration.pl?result=fail&comment=Can not complete the request.') and die "SQL Error: $DBI::errstr\n");

$dbh->disconnect;
print $cgi->redirect('login.pl?result=success&comment=Now you can log-in.');