

<?php

require_once 'head.php';
require_once 'naptar.php';

$naptar = new Naptar();
$year = 2022;
$month = 3;
$datum = strtotime("$year-$month-1");
require_once 'naptardb.php';
$db = new Database();
$munkaszunetek = $db->Munkaszunetek($year);
echo '<pre>';
//print_r($munkaszunetek);
echo '</pre>';
?>
<link href="naptar.css" rel="stylesheet" type="text/css"/>
        <div id="sheet">
            <h1>Naptár</h1>
            <span title=""></span>
            <?php
                
                $naptar->havi(2022, 3);
                $naptar->havi(2022, 4);
                $naptar->havi(2022, 5);
                $naptar->havi(2022, 6);
            ?>
        </div>
    </body>
</html>
