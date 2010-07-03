<?php
function sendmail($to,$body){
//Default receiver's address can be specified here, for the moment christopher@ekkitab.com assumed
    $receiver = $to;
    if($receiver == ""){
        $receiver = "christopher@ekkitab.com";
    }
    $subject = "Logs from updateprices";
    $sender = "support@ekkitab.com";
    $headers = "From:$sender" . "\r\n" .
    'X-Mailer: PHP/' . phpversion();
    echo "Sending update orices logs to $receiver\n";
    if (mail($receiver, $subject, $body, $headers)) {
        echo("Message successfully sent!\n");
    } else {
        echo("Message delivery failed...\n");
    }
}
    $fh = fopen ("php://stdin","r") or die("Could not read from standard input");
    $body = "";
    while ($contents = fgets($fh)){
        $body .= $contents;
    }
    if($body == ""){
        echo "No Message Body!!\n ";
    }
    if (!isset($argv[1]) ){
        echo "Usage $argv[0] <reciever1@domain.com,reciever2@domain.com,....>\nAs Reciever is not specified!! Assuming default\n";
        $to = "";
    }
    else{
        $to =  $argv[1];
    }
sendmail($to,$body)
?>
