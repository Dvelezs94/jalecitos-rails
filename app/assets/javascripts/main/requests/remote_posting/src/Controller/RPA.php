<?php 

namespace Drupal\remote_posting\Controller;

use Symfony\Component\HttpFoundation\Response;

use stdClass;

//includes
//of validations..
//use Drupal\remote_posting\Controller\Key;
//connection to db...
//use Drupal\remote_posting\Controller\Database;

class RPA{
    public function main(){
      //Get raw data
      $data = json_decode(file_get_contents("php://input"));

      //validate all the required data, if something is missing, returns an error array
      $error = $this->validate_req_data($data);

      //if there is an error, return it
      if($error){
        http_response_code(202);
        $response = new Response();
        $response->setContent(json_encode($error));
        $response->headers->set('Content-Type', 'application/json');
        return $response;
      }

      // // Instanciate DB and connect
      // $db = $this->db_connect();

      // //authenticate the key
      // $error_json = $this->authenticate_key($db, $data->auth_key);
      // 
      // //if the key is wrong, end execution
      // if($error_json){
      //    http_response_code(401);
      //    echo $error_json;
      //    die();
      // }
      
      $status_creation = $this->create_a_node($data);
      
      //send the status of the creation
      http_response_code(200);
      $response = new Response();
      $response->setContent(json_encode($status_creation));
      $response->headers->set('Content-Type', 'application/json');
      return $response;

    }
    public function validate_req_data($data){
        //required variables
        $data_req = array(
          //'auth_key',
          'subject',
          'content',
          'meta'
        );
        //check if all is complete
        foreach ($data_req as $req) {
          //if something is missing return a json to be displayed
          if( ! isset($data->$req ) ){
             return array('Error: '=>'Required ' .$req. ' is missing');
          }
        }
     }  
     
    public function create_a_node($data) {
            
        // global $user;
        // 
        // $node = new stdClass();
        // $node->title = $data->subject;
        // $node->type = "article";
        // // Sets some defaults. Invokes hook_prepare() and hook_node_prepare().
        // module_load_include('inc', 'node', 'node.pages');
        // node_object_prepare($node); 
        // // Or e.g. 'en' if locale is enabled.
        // $node->language = en; 
        // $node->uid = $user->uid; 
        // // Status is 1 or 0; published or not.
        // $node->status = 1; 
        // // Promote is 1 or 0; promoted to front page or not.
        // $node->promote = 0; 
        // // Comment is 0, 1, 2; 0 = disabled, 1 = read only, or 2 = read/write.
        // $node->comment = 1; 
        // 
        // // Text field
        // $node->body[$node->language][0]['value'] = $data->content;
        // $node->body[$node->language][0]['summary'] = $data->meta;
        // $node->body[$node->language][0]['format'] = 'filtered_html'; // If field has a format,  you need to define it. Here we define a default filtered_html format for a body field
        // 
        // 
        // $node = node_submit($node); // Prepare node for saving
        // node_save($node);
        //define entity type and bundle
        $entity_type="node";
        $bundle="article";

        //get definition of target entity type
        $entity_def = \Drupal::entityManager()->getDefinition($entity_type);

        //load up an array for creation
        $new_node=array(
          //set title
          'title' => $data->subject,

          //set body
          'body' => [
            'summary'=>$data->meta,
            'value'=> $data->content
            ],

          //use the entity definition to set the appropriate property for the bundle
          $entity_def->get('entity_keys')['bundle']=>$bundle
        );

        $new_post = \Drupal::entityManager()->getStorage($entity_type)->create($new_node);
        
        //if the post is created
        if( !empty($new_post) ){
          $new_post->save();
          return array('Status' => 'Post created');
        }
        //else
        return array('Error:' => 'Post not created');
      }   
      
    
  // public function authenticate_key($db, $auth_key){
  //     //Instantiate key object
  //     $key = new Key($db);
  // 
  //     //Get the key
  //     $key->auth_key = $auth_key;
  // 
  //     //if key is not valid return a json to be displayed
  //     if( ! $key->validate() ){
  //       return json_encode(
  //         array('Error:' => 'key is not valid')
  //       );
  //     }
  //   }
    
   
   // function db_connect(){
   //   $database = new Database();
   //   $db = $database->connect();
   //   return $db;
   // }
}