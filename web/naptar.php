<?php
class Naptar {
    private $datum= null;
    public function __construct() {
        ;
    }
    function havi($year,$month) {
        $day = 1;
        $this->datum=strtotime("$year-$month-1");
        
        echo '<h2>'.date('Y - M', $this->datum).'</h2>
        <table id="havinaptar">
                <thead>
                    <tr>
                        <th>H</th>
                        <th>K</th>
                        <th>Sze</th>
                        <th>Cs</th>
                        <th>P</th>
                        <th>Szo</th>
                        <th>V</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>';
        $h = intval(date('w', $this->datum)); //-- az első nap a hét hanyadik napjára esik (0-vasárnap, 1-hétfő, ...)
        $this->uresCella($h==0?6:$h-1); //-- az első sort feltöltjük üressel
        while(intval(date('m', $this->datum=strtotime("$year-$month-$day"))) == intval($month)) {
            echo intval(date('w', $this->datum))==1?'<tr>':''; //-- hétfő esetén új sort kezdünk
            $this->nap();
            echo intval(date('w', $this->datum))==0?'</tr>':''; //-- vasárnap esetén lezárjuk a sort
            $day++;
        }; 
        $day--;
        $h = intval(date('w', strtotime("$year-$month-$day")));
        $this->uresCella($h==0?0:7-$h); //-- utolsó sort is feltöltjük
        echo '</tr>                    
                </tbody>
            </table>';
    }
    
    private function nap() {
        //-- keressük a munkaszünetek között
        global $munkaszunetek;
        switch (intval(date('w', $this->datum))) {
            case 0:
                $style = "vasarnap";
                break;
            case 6:
                $style = "szombat";
                break;

            default:
                $style = "munkanap";
                break;
        }
        $title = "";
        foreach ($munkaszunetek as $row) {
            if($this->datum == strtotime($row["datum"])){
                $style = $row["style"];
                $title = $row["title"];
            }            
        }
//        $key = array_search(date('Y-m-d', $this->datum), array_column($munkaszunetek, 'datum'));
//        if()
        echo '<td title="'.$title.'" class="'.$style.'">'.date('j', $this->datum)."</td>";
    }
    
    private function uresCella($db) {
        for ($index = 0; $index < $db; $index++) {
            echo '<td class="ures">&nbsp;</td>';
        }
    }
}
