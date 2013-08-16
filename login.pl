#!/usr/bin/perl -w
use strict;
use CGI qw/:standard/;
use DBI;

print "Content-type:text/html\n\n";

print <<EOT;
<!DOCUMENT html>
<html lang="en">
	<head>
		<title>Login---Quotes</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link href="css/bootstrap.min.css" rel="stylesheet">

		<style type="text/css">
	    #centerLayer {
	     position: absolute; /* Абсолютное позиционирование */
	     width: 40%; /* Ширина слоя в процентах */
	     height: 30%; /* Высота слоя в процентах */
	     left: 50%; /* Положение слоя от левого края */
	     top: 50%; /* Положение слоя от верхнего края */
	     margin-left: -20%; /* Отступ слева */
	     margin-top: -10%; /* Отступ сверху */
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
		<p class="lead text-center">LOGIN</p>
EOT
		if(param('result') eq 'success')
		{
			print '<div class="alert alert-success">Registred. ' . param('comment') . '</div>';
		}
		if(param('result') eq 'fail')
		{
			print '<div class="alert alert-error">Error. ' . param('comment') . '</div>';
		}
print <<EOT;
			<form class="form-horizontal" action="log.pl" method="post">
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
			      <label class="checkbox">
			        <input type="checkbox" name="session"> Remember me
			      </label>
			      <button type="submit" class="btn">Sign in</button>&nbsp&nbsp&nbsp<a class="btn btn-primary" href="registration.pl">Register</a>
			    </div>
			  </div>
			</form>
		</div>
	</body>
</html>
EOT
