
<?php
//Code from Sam Cook, Library Connection, Inc
	$location=$_GET["location"];

//FIRST THREEVARIABLES ARE THE INFORMATION NEEDED FOR ACCESSING THE SIERRA SQL DATABASE
$hostname="";
$username="";
$password="";

//THIS IS THE NAME OF THE REPORT THAT WILL SHOW UP ON THE WEB PAGE
$reportname="";

//THIS IS THE FILENAME FOR WHEN IT IS EXPORTED TO EXCEL
$filename="";

//PUT YOUR REPORT QUERY HERE, INCLUDING WHATEVER VARIABLES YOU NEED. $location WOULD BE THE VARIABLE USED IN THIS REPORT TEMPLATE FOR REPORTING ON ONE LIBRARY
$query = "
		SELECT
			[fields]
		FROM
			[table]
		WHERE
			[variable]=$variablename
		ORDER BY
			[order field]
	";


// NOTE: You'll need the PHPExcel files, which can be found at https://github.com/PHPOffice/PHPExcel/tree/1.8/Classes
// Put these files in a Classes subfolder in the same folder your report file is in

// ALSO, add an export_files subfolder in the folder this report is in, and make sure the permissions are set so that files can be added to it through the website

	require_once dirname(__FILE__) . '/Classes/PHPExcel.php';
	$objPHPExcel = new PHPExcel();
	
	$objPHPExcel->getProperties()->setTitle($reportname);
	
	
	if ($location<>""){
	
		$dbconn = pg_connect("host=$hostname port=1032 dbname=iii user=$username password=$password connect_timeout=5")
			or die('Could not connect: ' . pg_last_error());
	
		$variablename=$_GET["variablename"];
	
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	
		$excelfilename=$filename."_".$location.".xlsx";


// ADD HOWEVER MANY COLUMNS YOU NEED HERE AND GIVE THEM THE APPROPRIATE NAMES

		$objPHPExcel->setActiveSheetIndex(0)
			->setCellValueByColumnAndRow(0,1, "First Column Name");
		$objPHPExcel->setActiveSheetIndex(0)
			->setCellValueByColumnAndRow(1,1, "Second Column Name");
		$objPHPExcel->setActiveSheetIndex(0)
			->setCellValueByColumnAndRow(2,1, "Third Column Name");
	}
	?>

	<html>
	<head>
	</head>
	
	<body>
	
	<div class="form-style-10" id="params">
		<form>
			<select name="location">
				<option>Select a different library</option>

<!-- PUT IN MORE OPTION TAGS FOR AS MANY LIBRARIES AS YOU NEED, REPLACING THE libraycode VALUE FOR BOTH INSTANCES OF EACH OPTION -->

				<option value="librarycode" <?if ($location=='librarycode') {echo "selected";}?>>Library name</option>
			</select>
			<input type="submit" value="Run Report"/> 
		</form>
	</div>
	
	<?php
	if($location=="") {
		echo "<div style='display:none;'>";
	}
	?>
	
	<button id="excelbutton" onclick="location.href='export_files/<?php echo $excelfilename; ?>';" >Export to Excel</button>
	
	<?php 
	if($location=="") {
		echo "</div>";
	}
	
	if ($location<>"") {
		echo "<table style='border-collapse:collapse;'>\n";
		echo "<thead id='table_header'>";

// PUT IN AS MANY <td> TAGS AS YOU NEED FOR EACH OF THE COLUMN HEADERS

		echo "<tr><td>Table Column Header</td></tr>\n";
		echo "</thead>";
		$x=0;
		$y=2;
	
		while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
			echo "\t<tr>\n";
			foreach ($line as $col_value) {
	
	        echo "\t\t<td>";
		echo $col_value;
		$objPHPExcel->setActiveSheetIndex(0)
		->setCellValueByColumnAndRow($x,$y,$col_value);
		echo "</td>\n";
		$x++;
	    }
	    echo "\t</tr>\n";
	    $y++;
	    $x=0;
	}
	echo "</table>\n";
	
	pg_free_result($result);
	pg_close($dbconn);
	
	$callStartTime = microtime(true);
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$savename="export_files/".$excelfilename;
	$objWriter->save($savename);
	}
	
	
	?>
	<?php 
	if($location=="") {
	echo "</div>";
	}
	?>
	
	</body>
	</html>	
