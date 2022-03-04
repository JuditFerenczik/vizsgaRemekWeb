<!--Jelszó módosítása-->

<?php

//if (isset($_SESSION['szemely_id'])) {

require_once 'connect.php';

if (filter_input(INPUT_POST, "modositas", FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE)) {
    $regiJelszo = filter_input(INPUT_POST, "regiJelszo", FILTER_SANITIZE_STRING);
    $ujJelszo = filter_input(INPUT_POST, "ujJelszo", FILTER_SANITIZE_STRING);
    $jelszoMegerosites = filter_input(INPUT_POST, "jelszoMegerosites", FILTER_SANITIZE_STRING);
    if ($regiJelszo == null || $ujJelszo == null || $jelszoMegerosites == null) {
        $_SESSION['error'] = 'Az összes mező kitöltése kötelező!';
        include 'modositas.php';
    } elseif ($ujJelszo !== $jelszoMegerosites) {
        $_SESSION['error'] = 'A két jelszó nem egyezik!';
        include 'modositas.php';
//        header("location: modositas.php");
    } else {
        $regiJelszo = sha1($regiJelszo);
        $ujJelszo = sha1($ujJelszo);
        $sql = "SELECT `jelszo` FROM `szemelyek` WHERE `szemely_id`= '$szemely_id' AND `jelszo`= '$regiJelszo'";
        $result = mysqli_query($conn, $sql);
        if (mysqli_num_rows($result) === 1) {

            $sql_2 = "UPDATE `szemelyek` SET `jelszo`= '$ujJelszo' WHERE szemely_id='$szemely_id'";
            mysqli_query($conn, $sql_2);
            $_SESSION['success'] = "Sikeres jelszóváltoztatás";
            include 'modositas.php';
//            header("Location: modositas.php");
            exit();
        } else {
            $_SESSION['error'] = "Helytelen jelszó";
            include 'modositas.php';
//            header("Location: modositas.php");
            exit();
        }
    }
}

