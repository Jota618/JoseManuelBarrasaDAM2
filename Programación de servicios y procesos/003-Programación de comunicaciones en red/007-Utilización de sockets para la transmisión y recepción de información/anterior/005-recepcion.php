<?php
function receiveEmail() {
    $imapServer = 'imap.ionos.es';
    $port = 993; // IMAP over SSL
    $username = 'dam@jocarsa.com';
    $password = 'TAME123$';

    // Establish connection
    $socket = fsockopen("ssl://$imapServer", $port, $errno, $errstr, 10);
    if (!$socket) {
        echo "Error: $errstr ($errno)";
        return false;
    }

    // Initial server response
    fgets($socket, 512);

    // Login
    fwrite($socket, "A001 LOGIN $username $password\r\n");
    fgets($socket, 512);

    // Select INBOX
    fwrite($socket, "A002 SELECT INBOX\r\n");
    fgets($socket, 512);

    // Search for all emails
    fwrite($socket, "A003 SEARCH ALL\r\n");
    $result = fgets($socket, 512);
    var_dump($result);

    // Parse email IDs from the result
    if (preg_match('/^\* SEARCH (.+)$/', $result, $matches)) {
        $emailIds = explode(' ', $matches[1]);
        foreach ($emailIds as $emailId) {
        	echo "ok mail";
            // Fetch email headers and body for each email
            fwrite($socket, "A004 FETCH $emailId BODY[HEADER]\r\n");
            while ($line = fgets($socket, 512)) {
                if (strpos($line, "A004 OK") !== false) break;
                echo $line; // Print header data

                // Fetch email body
                fwrite($socket, "A005 FETCH $emailId BODY[TEXT]\r\n");
                while ($line = fgets($socket, 512)) {
                    if (strpos($line, "A005 OK") !== false) break;
                    echo $line; // Print email body
                }
            }
        }
    }

    // Logout
    fwrite($socket, "A006 LOGOUT\r\n");
    fclose($socket);
}

receiveEmail();
echo "ok";
?>

