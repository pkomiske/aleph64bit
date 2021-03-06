#!/usr/local/bin/perl

$homedir = $ENV{HOME};

# $alephcert    = " ALEPHcert.pem";

# Make the Aleph root certificate.
# All useful informations are in the openssl.cnf file, in the same directory

$request_cmd  = "../openssl/bin/openssl req ";
$request_args = " -x509 -config openssl.cnf ".
                " -days 3650 -newkey rsa:512 ";
$alephcert    = " ALEPHcert.pem";
$alephkey     = " private/ALEPHkey.pem";
$outfiles     = " -keyout $alephkey -out $alephcert";

$string = $request_cmd.$request_args.$outfiles;

system($string);

print "Do you want to verify ? y/n [y]";

$input = <STDIN>;
$input =~ s/Y/y/;
$input =~ s/^$/y/;
if($input =~ /^y/){
   print "verifying\n";
}

system("../openssl/bin/openssl x509 -in $alephcert -text");

$dest   = "\~/WWW/cert_authority/ALEPHcert.cacert";

print "I can now install the certificate in $dest \n";

do {
  print "Install ? y/n ";
  $input = <STDIN>;
  $input =~ s/Y/y/;
}while($input =~ /^$/);

$dest =~ s/\~/$homedir/;

print "Installing the certificate in $dest \n";

if($input =~ /^y/){
   system("cp $alephcert $dest");
   print "Certificate was installed\n";
}


