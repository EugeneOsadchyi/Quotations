#!/usr/bin/perl -w
use CGI qw/:standard/;
use CGI::Cookie;
use DBI;
use WWW::Curl::Easy;

%cookies = CGI::Cookie->fetch;

if(!defined(%cookies))
{
	print redirect('login.pl?result=fail&comment=You have to login first.');	
}

my $user = $cookies{'Login'}->value;

my $dsn = "dbi:mysql:database=Quotations;host=localhost;port=3306";
my $dbh = DBI->connect($dsn, "root", "PerlStudent") or (print redirect('login.pl?fail&comment=Can not connect to database.') and die "SQL Error: $DBI::errstr\n");

my $sth = $dbh->prepare('select * from users where login = ?');
$sth->execute($user);

my $ans = $sth->fetchrow_hashref;

if(!defined($ans))
{
	print redirect('login.pl?result=fail&comment=Incorrect user');	
}

sub get_last_id {
    my $curl = WWW::Curl::Easy->new;
    $curl->setopt(CURLOPT_URL, 'http://bash.im/');
    my $page;
    $curl->setopt(CURLOPT_WRITEDATA,\$page);
    my $page_code = $curl->perform;
    my $last_quote_id;
    if ($page_code == 0) {
        my $code = $curl->getinfo(CURLINFO_HTTP_CODE);
        my @array = split(/</, $page);
        foreach my $tmp (@array) {
            $last_quote_id = $tmp and last if ($tmp =~ m|quote/[0-9]+/rulez|);
        }
        $last_quote_id =~ s|.*quote/([\d]+)/.*|$1|;
        if ($last_quote_id !~ /^+\d+$/) {
            print "Error!" and return undef;
        }
    } else {
        return undef;
    }
    return $last_quote_id;
}

sub get_quote_by_id($) {
    return undef if (not defined $_[0]);
    my $curl = WWW::Curl::Easy->new;
    $curl->setopt(CURLOPT_URL, 'http://bash.im/quote/'.$_[0]);
    my $response_body;
    $curl->setopt(CURLOPT_WRITEDATA,\$response_body);

    my $retcode = $curl->perform;
    my $text=undef;
    if ($retcode == 0) {
        my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
        my @array = split(/<\/div>/, $response_body);

        foreach my $tmp (@array) {
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


my $value = $ans->{'shown_quotes'};
my $last = get_last_id;


print "Content-type:text/html\n\n";

print <<EOT;
<!DOCUMENT html>
<html lang="en">
	<head>
		<title>Home---Quotes</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link href="css/bootstrap.min.css" rel="stylesheet">

		<style type="text/css">
		    #centerLayer {
		     position: absolute; /* Абсолютное позиционирование */
		     width: 40%; /* Ширина слоя в процентах */
		     height: 30%; /* Высота слоя в процентах */
		     left: 50%;  /*Положение слоя от левого края */*/
		     top: 50%; /* Положение слоя от верхнего края */
		     margin-left: -20%; /* Отступ слева */
		     margin-top: -0%; /* Отступ сверху */
		    }
	    </style>
	</head>
	<body>
		<script src="http://code.jquery.com/jquery.js"></script>
		<script src="js/bootstrap.min.js"></script>

		<div class="container">
			<div class="page-header">
				<h1>Quotes <small>Read the best quotes from <strong>bash.org.ru</strong></small>
			</div>
			<ul class="nav nav-pills">
EOT
print '<li class="active"><a href="index.pl">Home</a></li>';

print '<li><a href="logout.pl?Login=' . $user . '">Logout ' . $user . '</a></li>';

print <<EOT;
			</ul>
		</div>
		<div class="container"  id="centerLayer">
EOT

print "<p class=\"lead text-left\">Quote #" . $value . "</p><br><blockquote><p>" . get_quote_by_id($value) . "</p></blockquote><ul class=\"pager\">";
if($value>1)
{
	print '<li><a href="move.pl?dir=prev&last=' . $last . '">Previous</a></li>';
}
if($value<$last)
{
	print '<li><a href="move.pl?dir=next&last=' . $last . '">Next</a></li>';
}
print "</ul>";

print <<EOT;
		</div>
	</body>
</html>
EOT

