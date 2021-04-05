function sendmail_from_totem(recipients, subject, text)


setpref('Internet','SMTP_Server','smtp.web.de');
setpref('Internet','E_mail','your_custom_mailadress@gmail.com')

mail = 'your_custom_mailadress@gmail.com';
psswd = 'password_of_your_mailadress';
host = 'smtp.gmail.com';
port  = '465';

setpref( 'Internet', 'E_mail',          mail );
setpref( 'Internet', 'SMTP_Server',     host );
setpref( 'Internet', 'SMTP_Username',   mail );
setpref( 'Internet', 'SMTP_Password',   psswd );
props = java.lang.System.getProperties;
props.setProperty( 'mail.smtp.user',    mail );
props.setProperty( 'mail.smtp.host',    host );
props.setProperty( 'mail.smtp.port',    port );
props.setProperty( 'mail.smtp.debug',   'true' );
props.setProperty( 'mail.smtp.auth',    'true' );

props.setProperty( 'mail.smtp.socketFactory.port', port );
props.setProperty( 'mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory' );
props.setProperty( 'mail.smtp.socketFactory.fallback', 'false' );



sendmail( recipients ,  subject, text );
