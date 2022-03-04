<!--Bejelentkező oldal-->
<?php
require_once 'head.php';
require_once 'ellenorzes.php';
?>
<div>
    <img id="fokep" src="kepek/work-g9338c4078_1280.png" alt=""/>
    <div class="logo">
        <a href="index.php"><img id="logokep" src="kepek/logo.png" alt=""/></a>
    </div>
    <div class="container-fluid">
        <p>MŰSZAKBEOSZTÁS CÉGEKNEK</p>
        <h1>Hozza létre és ossza meg</h1> 
        <h3>beosztottjai munkarendjét percek alatt!<br>Kövesse és módosítsa bármikor munkabeosztását!</h3>
        <div class="doboz">
            <h4>Lássuk a beosztásokat!</h4>
            <form class="form-inline" method="POST">

                <input type="text"  class ="form-control w-35 m-2" name="email" id="email" value="" placeholder="E-mail cím">

                <input type="password" class ="form-control w-35 m-2" name="jelszo" id="jelszo" value="" placeholder="Jelszó">
                <button type="submit" class="btn btn-warning btn-lg m-2" name="adatok" value="true" >Belépés</button>

            </form>
            <?php
//            session_start();
            if (isset($_SESSION['error'])) {
                echo '<div id="error" style="color:red;">' . $_SESSION['error'] . '</div>';
                unset($_SESSION['error']);
                exit();
            }
            ?>
        </div>
    </div>
</div>
<!--</body>
</html>-->
