#!/usr/bin/perl -w
use strict;
use CGI;

print "Content-type: text/html\n\n";

my $cgi = CGI->new();

print <<EOT;
<!DOCUMENT html>
<html lang="en">
	<head>
		<title>Registration---Quotes</title>
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
			  <li><a href="index.pl">Home</a></li>
			  <li class="active"><a href="login.pl">Login</a></li>
			</ul>
		</div>
		<div class="container"  id="centerLayer">
		<p class="lead">Registration</p>
EOT
		if($cgi->param('result') eq 'success')
		{
			print '<div class="alert alert-success">Registred.</div>';
		}
		elsif($cgi->param('result') eq 'fail')
		{
			print '<div class="alert alert-error">Error. ' . $cgi->param('comment') . '</div>';
		}
print <<EOT;
			<form class="form-horizontal" action="reg.pl" method="post">
			  <div class="control-group">
			    <label class="control-label" for="inputLogin">Login</label>
			    <div class="controls">
			      <input type="text" name="login" id="inputLogin" placeholder="Login" required>
			    </div>
			  </div>
			  <div class="control-group">
			    <label class="control-label" for="inputPassword">Password</label>
			    <div class="controls">
			      <input type="password" name="password" id="inputPassword" placeholder="Password" required>
			    </div>
			  </div>
			  <div class="control-group">
			    <div class="controls">
			        <button type="submit" class="btn btn-primary">Register</button>&nbsp&nbsp&nbsp<INPUT TYPE="RESET" CLASS="btn" VALUE="Clear">
			    </div>
			  </div>
			</form>
		</div>
	</body>
</html>
EOT
