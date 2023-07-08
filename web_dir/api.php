<?php
include 'config.php';
include 'functions.php';

if ($_POST["apikey"] != $apiKey)
    die("false");

if ($_POST['action'] == "openvpn-running")
    echo is_openvpn_installed();

if ($_POST["action"] == "status")
    echo getServerStatus();

if ($_POST["action"] == "bwgraph")
    echo getBandwidthGraph();

if ($_POST["action"] == "connectedclients")
    echo getConnectedClients();

if ($_POST["action"] == "createclient") {
    if (!isset($_POST["clientName"])) {
        die("Data not found!");
    }
    // Output the result
    header('Content-Type: application/json');
    echo json_encode(createClient($_POST["clientName"]));
    die;
}

if ($_POST["action"] == "getclienttemplate")
    echo getClientTemplate();

if ($_POST["action"] == "deleteclient")
    echo deleteClient($_POST["clientName"]) ? 'true' : 'false';

if ($_POST["action"] == "setvpnport")
    echo setVPNPort($_POST["vpnPort"], $_POST["setIP"]) ? 'true' : 'false';

if ($_POST["action"] == "setspeedlimit")
    echo setSpeedLimit($_POST["limit"]) ? 'true' : 'false';

if ($_POST["action"] == "setvpnprotocol")
    echo setVPNProtocol($_POST["vpnProtocol"]) ? 'true' : 'false';

if ($_POST["action"] == "setvpndns")
    echo setVPNDNS($_POST["vpnDNS"]) ? 'true' : 'false';

if ($_POST["action"] == "toggleserverstatus")
    toggleVPNStatus();
