<?php

define (DEFAULT_ADDRESSEE, "christopher@ekkitab.com");
define (SENDER, "support@ekkitab.com");
define (DEFAULT_SUBJECT, "Email from Ekkitab");

    function sendmail($to, $subject, $body){

        $sender = SENDER;
        $headers = "From:$sender" . "\r\n" .  'X-Mailer: PHP/' . phpversion();

        if (mail($to, $subject, $body, $headers)) {
            return 0;
        }
        return 1;
    }

    $subject = DEFAULT_SUBJECT;
    $to = DEFAULT_ADDRESSEE;

    for ($i=1; $i<$argc; $i++) {

       switch($argv[$i]) {
            case "-s":
                   if ($i+1 >= $argc) {
                      echo "Fatal: Subject specified but no value supplied.\n";
                      echo "Usage: " . $argv[0] . " [ -s <subject> ] [ email address [, email address]... ]\n" ;
                      exit(1);
                   }
                   else {
                      $subject = $argv[$i+1];
                      $i++;
                   }
                   break;

            default:   
                   $to = $argv[$i];
                   break;
       }
   }

   $fh = fopen ("php://stdin","r") or die ("Failed: Could not read from standard input.\n");
   $body = "";
   while ($contents = fgets($fh)){
        $body .= $contents;
   }
   sendmail($to, $subject, $body)
?>
