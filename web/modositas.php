<!--Személyes adatok/jelszó módosítás-->

<?php
require_once 'head.php';
require_once 'jelszo_mod.php';

?>
<form method="POST">
    <h2>Adatok módosítása</h2>
    <label>Régi jelszó</label>
    <input type="password" 
           name="regiJelszo" 
           placeholder="Régi jelszó">
    <br>

    <label>Új jelszó</label>
    <input type="password" 
           name="ujJelszo" 
           placeholder="Új jelszó">
    <br>

    <label>Új jelszó megerősítése</label>
    <input type="password" 
           name="jelszoMegerosites" 
           placeholder="Új jelszó megerősítése">
    <br>

    <button type="submit" name="modositas" value = "true">Mentés</button>
</form>
<?php
if (isset($_SESSION['error'])) {
echo '<div id="error" style="color:red;">' . $_SESSION['error'] . '</div>';
unset($_SESSION['error']);
exit();
}
if (isset($_SESSION['success'])) {
echo '<div id="success" style="color:green;">' . $_SESSION['success'] . '</div>';
unset($_SESSION['success']);
exit();
}
?>

