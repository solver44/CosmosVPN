<?php

function is_openvpn_installed()
{
     // Command to check if OpenVPN is installed
     $command = 'which openvpn';

     // Execute the command using shell_exec
     $output = shell_exec($command);

     // Check if the output contains the path to OpenVPN
     if (!empty($output) && strpos($output, '/openvpn') !== false) {
          return "true";
     }

     return "false";
}

function getServerStatus()
{
     return shell_exec("service openvpn status");
}

function getBandwidthGraph()
{
     return shell_exec("base64 -w 0 /var/www/bwgraph.jpg");
}

function getConnectedClients()
{
     return shell_exec("sudo /var/www/returnConnectedClients.sh");
}

function createClient1($clientName, $usePassword)
{
     $passwordOption = $usePassword == "yes" ? 'yes' : 'no';
     $output = shell_exec("sudo /var/www/createClient.sh $clientName $passwordOption");

     // Check if the user already exists
     $userExists = strpos($output, 'User already exists') !== false;
     if($userExists == false){
          $output = explode(".inline", $output)[1];
     }else{
          $output = explode("User already exists", $output)[1];
     }

     // Separate the generated content
     $generatedContent = explode("<ca>", $output);
     $username = $clientName;
     $password = $usePassword ? trim($generatedContent[0]) : null;
     $config = trim('<ca>' . $generatedContent[1]);

     return [
          'username' => $username,
          'password' => $password,
          'config' => $config,
          'user_exists' => $userExists,
     ];
}
function createClient($clientName, $usePassword)
{
    // Call the new_client_with_user.sh Bash script to create the user and generate the OpenVPN configuration
    $bashScriptPath = "/var/www/createClient.sh";
    $output = shell_exec("sudo {$bashScriptPath} {$clientName}");

    // Parse the output to get the username, password, and OpenVPN configuration
    preg_match('/Username: (\S+)/', $output, $usernameMatches);
    preg_match('/Password: (\S+)/', $output, $passwordMatches);
    preg_match('/(<ca>[\s\S]*<\/tls-crypt>)/', $output, $configMatches);

    $username = $usernameMatches[1];
    $password = $passwordMatches[1];
    $clientConfig = 'auth-user-pass\n' . $configMatches[1];

    return [
        'username' => $username,
        'password' => $password,
        'config' => $clientConfig,
    ];
}

function deleteClient($clientName)
{
     $deleteClient = shell_exec("sudo /var/www/deleteClient.sh $clientName");
     return str_contains($deleteClient, "Revocation was successful.");
}

function getClientTemplate()
{
     return shell_exec("sudo /var/www/returnClientTemplate.sh");
}

function setVPNPort($port, $ip)
{
     return shell_exec("sudo /var/www/setVPNPort.sh $port $ip");
}

function setVPNProtocol($protocol)
{
     return shell_exec("sudo /var/www/setVPNProtocol.sh $protocol");
}

function setVPNDNS($dns)
{
     return shell_exec("sudo /var/www/setVPNDNS.sh $dns");
}

function toggleVPNStatus()
{
     return shell_exec("sudo /var/www/toggleVPNStatus.sh");
}
