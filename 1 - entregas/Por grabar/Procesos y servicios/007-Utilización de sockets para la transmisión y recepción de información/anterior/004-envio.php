<?php
function sendEmail($to, $subject, $message, $headers) {
    $smtpServer = 'smtp.ionos.es';
    $port = 587; // Use 587 for TLS or 465 for SSL
    $username = 'dam@jocarsa.com';
    $password = 'TAME123$';
    $socket = fsockopen($smtpServer, $port, $errno, $errstr, 10);
    if (!$socket) {
        echo "Error: $errstr ($errno)";
        return false;
    }

    fgets($socket, 515);

    fwrite($socket, "HELO $smtpServer\r\n");
    fgets($socket, 515);

    fwrite($socket, "STARTTLS\r\n");
    fgets($socket, 515);
    stream_socket_enable_crypto($socket, true, STREAM_CRYPTO_METHOD_TLS_CLIENT);

    fwrite($socket, "AUTH LOGIN\r\n");
    fgets($socket, 515);
    fwrite($socket, base64_encode($username) . "\r\n");
    fgets($socket, 515);
    fwrite($socket, base64_encode($password) . "\r\n");
    fgets($socket, 515);

    fwrite($socket, "MAIL FROM: <$username>\r\n");
    fgets($socket, 515);

    fwrite($socket, "RCPT TO: <$to>\r\n");
    fgets($socket, 515);

    fwrite($socket, "DATA\r\n");
    fgets($socket, 515);
    fwrite($socket, "Subject: $subject\r\n$headers\r\n\r\n$message\r\n.\r\n");
    fgets($socket, 515);

    fwrite($socket, "QUIT\r\n");
    fgets($socket, 515);

    fclose($socket);
    return true;
}

$to = 'vcarratala@hotmail.com';
$subject = 'Email desde localhost';
$message = 'Este es un mensaje.';
$headers = "From: dam@jocarsa.com\r\n";

if (sendEmail($to, $subject, $message, $headers)) {
    echo "Email sent successfully!";
} else {
    echo "Failed to send email.";
}
?>

