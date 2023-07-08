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

function createClient($clientName)
{
     $output = shell_exec("sudo /var/www/createClient.sh \"$clientName\"");

     // Check if the user already exists
     $userExists = strpos($output, 'User already exists') !== false;
     if ($userExists !== false) {
          $output = explode("User already exists", $output)[1];
     }

     // Separate the generated content
     $generatedContent = explode("<ca>", $output);
     $username = $clientName;
     $password = trim($generatedContent[0]);
     $config = trim('<ca>' . $generatedContent[1]);

     return [
          'username' => $username,
          'password' => $password,
          'config' => $config,
          'user_exists' => $userExists,
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
function setSpeedLimit($limit)
{
     return shell_exec("sudo /var/www/changeSpeedLimit.sh $limit");
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
