#!/usr/bin/perl -w
use CGI;
use DBI;
use WWW::Curl::Easy;

my $cgi = CGI->new();

my $id = $cgi->param('id');
my $dir = $cgi->param('dir');
my $last = $cgi->param('last');

my $dsn = "dbi:mysql:database=Quotations;host=localhost;port=3306";
my $dbh = DBI->connect($dsn, "root", "PerlStudent") or (print $cgi->redirect('login.pl?fail&comment=Can not connect to database.') and die "SQL Error: $DBI::errstr\n");

my $sth = $dbh->prepare("select * from users where id = ?");
$sth->execute($id);

my $ans = $sth->fetchrow_hashref;

my $value = $ans->{'shown_quotes'};

sub get_quote_by_id($) {
    return undef if (not defined $_[0]);
    my $curl = WWW::Curl::Easy->new;
    $curl->setopt(CURLOPT_URL, 'http://bash.im/quote/'.$_[0]);
    # A filehandle, reference to a scalar or reference to a typeglob can be used here.
    my $response_body;
    $curl->setopt(CURLOPT_WRITEDATA,\$response_body);

    # Starts the actual request
    my $retcode = $curl->perform;
    my $text=undef;
    # Looking at the results...
    if ($retcode == 0) {
        #print("Transfer went ok\n");
        my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
        my @array = split(/<\/div>/, $response_body);

        foreach my $tmp (@array) { # Ugly code, but grep not work
            $text = $tmp and last if ($tmp =~ m|class="text"|);
        }
        if(defined($text))
        {
        	$text.="</div><br>\n";
        }
        
    } else {
        return undef;
    }
    return $text;
}

my $i = 1;

if($dir eq 'next')
{
    while(!defined(get_quote_by_id($value+$i)) && ($value+$i)<$last)
    {
        $i++;
    }
    if(defined(get_quote_by_id($value+$i)))
    {
        $dbh->do("update users set shown_quotes = ? where id = ? ", {}, ($value+$i), $id );
    }
}
elsif($dir eq 'prev')
{
    while(!defined(get_quote_by_id($value-$i)) && ($value-$i)>1)
    {
        $i++;
    }
    if(defined(get_quote_by_id($value-$i)))
    {
        $dbh->do("update users set shown_quotes = ? where id = ? ", {}, ($value-$i), $id );
    }
}
print $cgi->redirect('index.pl?id='.$id);