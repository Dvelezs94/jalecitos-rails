<?php

namespace Drupal\remote_posting\Controller;

class Key
{
 //DB Stuff
 private $conn;
 private $table = 'auth_keys';

 //Key properties
 public $id;
 public $auth_key;

 //Constructor with DB
 public function __construct($db){
   $this->conn = $db;
 }

 //Validate Key
 public function validate(){
   //Create query to search the key
   $query = 'SELECT count(*) FROM ' . $this->table . ' WHERE auth_key = :auth_key LIMIT 0,1';

   //Prepare statement(this is a PDO)
   $stmt = $this->conn->prepare($query);
   
   //clean data
   $this->auth_key = htmlspecialchars(strip_tags($this->auth_key));

   //Bind data
   $stmt->bindParam( ':auth_key' ,$this->auth_key);

   //Execute query
   $stmt->execute();
   
   //count rows
   $num_rows = $stmt->fetchColumn();
    //validate if the key exists
   if( $num_rows ){
     return true;
    }
   return false;
  }
}
