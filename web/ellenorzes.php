<!--Email és jelszó ellenőrzése-->

<?php

require_once 'connect.php';

if (filter_input(INPUT_POST, "adatok", FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE)) {
    $jelszo = filter_input(INPUT_POST, "jelszo", FILTER_SANITIZE_STRING);
    $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_EMAIL);
    if ($jelszo == null || $email == null) {
        $_SESSION['error'] = 'Az összes mező kitöltése kötelező!';
        include 'login.php';
    }
    if ($stmt = $conn->prepare('SELECT `jelszo`, `fonok`, `szemely_id`, `nev` FROM `szemelyek` WHERE `email`= ?')) {


        $stmt->bind_param('s', $email);
        $stmt->execute();

        $stmt->store_result();

        if ($stmt->num_rows > 0) {

            $stmt->bind_result($jelszo, $fonok, $szemely_id, $nev);
            $stmt->fetch();

            $teljes = explode(" ", $nev);
            $keresztnev = $teljes[1];
            if (sha1($_POST['jelszo']) == $jelszo) {

                $_SESSION['login'] = true;
                $_SESSION['szemely_id'] = $szemely_id;
                $_SESSION['nev'] = $keresztnev;

                if ($fonok == 0) {
                    $_SESSION["jog"] = "fonok";
                    header('location:index.php');
                } else {
                    $_SESSION["jog"] = "alkalmazott";
                    header('location:index.php');
                }
            } else {

                $_SESSION['error'] = 'Helytelen felhasználónév vagy jelszó!';
                header('location:index.php');
//            echo 'Hibás jelszó';
            }
        } else {

            $_SESSION['error'] = 'Helytelen felhasználónév vagy jelszó!';
            include 'login.php';
//        echo 'Hibás email'; 
        }

        $stmt->close();
    }
}
?>
