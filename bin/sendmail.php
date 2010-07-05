<?php

define (DEFAULT_ADDRESSEE, "christopher@ekkitab.com");
define (SENDER, "support@ekkitab.com");
define (DEFAULT_SUBJECT, "Email from Ekkitab");
define (MAXLINES_IN_BODY, 100);

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

   $lines = 0;
   while ($contents = fgets($fh)){
        $lines++;
        if ($lines <= MAXLINES_IN_BODY) {
            $body .= $contents;
        }
   }
   if ($lines > MAXLINES_IN_BODY) {
        $body .= "\n ..... more .....\n";
   }
   sendmail($to, $subject, $body)
?>
