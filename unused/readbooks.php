<?php

// global variables
$fp_archive = "";
$fp_error = "";
$fp = "";


// function to open a file to read data
function open_file($file)
{ 
	global $fp_archive,$fp_error,$fp;
	// create an update archive file
	$t_ar = './ar/'.$file;
	$fp_archive = fopen($t_ar,"w");
	echo $file.' archive opned<br>';

	//create an error file log
	$t_er = './er/'.$file;
	$fp_error = fopen($t_er,"w");
	echo $file.' error file opned<br>';
			
	
	//crate an file pointer for the csv
	$file = './tt/'.$file;
	$fp = fopen($file,"r")
		or throwme(5);
	echo $file.'<br>opened<br>';
		
}


// function to close the opened files
function close_file()
{
	global $fp_archive,$fp_error,$fp;
	
	
	// close the archive log file
	fclose($fp_archive);
	echo ' archive closed<br>';
	
	// close the error log file
	fclose($fp_error);
	echo ' error closed<br>';
	
	// close the csv file
	fclose($fp);
	echo "closed<br>";
}


// function to get the file list
function get_flist()
{
	$TrackDir = opendir("./tt");


	while ($file = readdir($TrackDir)) 
		{ 
		if ($file == "." || $file == "..") { } 
			 else {
					if(!empty($flist))
					{
						$flist = $flist.','.$file;
					}
					else
					{
						$flist = $file;
					}


                  }
         } 
	closedir($TrackDir);
	echo 'file list obtained';
	return $flist;
}



// this function normalizes the data in the publishers feed and updated the refdb
Function update_ref()
{
	global $fp;
  
  // normalizing the data order.
  
  $line = fgets($fp);
  $line1 = explode(",",$line);
	
	$i=0;

  While(!empty($line1[$i]))
  { 
	If (trim($line1[$i])=='author'||'AUTHOR')
	  {$pos_au = $i;}
	If (trim($line1[$i])=='title'||'TITLE')
	  {$pos_ti = $i;}
	If (trim($line1[$i])=='binding'||'BINDING')
	  {$pos_bi = $i;}
	If (trim($line1[$i])=='description'||'DESCRIPTION')
	  {$pos_de = $i;}
	If (trim($line1[$i])=='isbn'||'ISBN')
	  {$pos_is = $i;}
	$i = $i + 1;
	
   }

  // connecting to the refdb
  $db = mysqli_connect("localhost","root","","ref1");
		
   
 // updating the refdb
 while (!feof($fp))
	{
	 try
		{
			
		$line = fgets($fp);
		$t_line = explode(",",$line);
		// checking if the ISBN exists
		 $query = "select * from book_info where ISBN =".$t_line[$pos_is] ;
		 $result = mysqli_query($db,$query)
					or throwme(2);
					
		 $row = mysqli_fetch_array($result);   
		
		 if (empty($row))
			{	// adding a new book in the refdb
			$query = "INSERT INTO book_info values($t_line[$pos_is],'$t_line[$pos_au]','$t_line[$pos_ti]','$t_line[$pos_bi]','$t_line[$pos_de]','all','2009-10-01')";	
		    $result = mysqli_query($db,$query) 
		    or throw_sql(1,$line);
			echo 'New book Added <br>';
		    }
		else 
			{// updating the book attributes
			
			$change = 0;// flag to update the date		
			
			if($row['binding']!=$t_line[$pos_bi])
				{
				$query = "UPDATE book_info SET binding = '$t_line[$pos_bi]' WHERE ISBN = $t_line[$pos_is]";
      			$result = mysqli_query($db,$query)
						or throw_sql(1,$line);
				$change = 1;
				}
			if($row['description']!=$t_line[$pos_bi])
				{
				$query = "UPDATE book_info SET binding = '$t_line[$pos_de]' WHERE ISBN = $t_line[$pos_is]";
				$result = mysqli_query($db,$query)
					or throw_sql(1,$line);
				$change = 1;
				}
		 // check the flag and update the update_date field
			 if($change == 1)
				{
				$query = "UPDATE `book_info` SET `update_date` = curdate() WHERE `ISBN` = $t_line[$pos_is]" ;
      			$result = mysqli_query($db,$query)
					or throw_sql(1,$line);
			
				}
			}// of else block
			
		
		}// end of try block
	  catch (exception $e)
			{ echo 'the exception sql caugth and logged', $e->getMessage() , '<br>';
			}
	}// end of while block  
	
	// diconnecting from the refdb
		mysqli_close($db);

}// end of update_ref

// this function throws an exception

function throwme($code)
{
	throw new exception($code);
}


// this function throws a exception for mysqli error

function throw_sql($code,$line)
{ 
global $fp_error;
	if($code == 1)
	fwrite($fp_error,"error while writing $line into db \r\n");
	throw new exception("error while writing"); 


}




// main function


$slist = get_flist();
$list = explode(",",$slist);
$f_count = 0;

	while(!empty($list[$f_count]))
	{
		try{

				open_file($list[$f_count]);
				update_ref();
				close_file();
			}
		catch (exception $e)
		{ echo 'caught the exception' , $e->getMessage(),'<br>';
		}

		$f_count = $f_count + 1;

	}
// end of main function

?>
