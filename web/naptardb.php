<?php
class Database {
    private $mysqli = null;

    public function __construct($host = 'localhost', $user = 'root', $pass = '', $database = 'vizsgaremek_db') {
        $this->connect($host, $user, $pass, $database);
    }
    
    private function connect($host = 'localhost', $user = 'root', $pass = '', $database = 'vizsgaremek_db') {
        $this->mysqli = new mysqli($host,$user,$pass,$database);
        if ($this->mysqli -> connect_errno) {
            echo "Failed to connect to MySQL: " . $this->mysqli -> connect_error;
            exit();
        }
    }
    
    public function Munkaszunetek($year) {
        $sql = "SELECT * FROM `munkaszunetek`  WHERE year(`datum`)=$year;";
        $result = $this->mysqli->query($sql);
        // Associative array
        $rows = array();
        while($row = $result->fetch_assoc()) {
            $rows[] = $row;
        }
        return $rows;
    }
}