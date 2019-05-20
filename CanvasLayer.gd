extends CanvasLayer
# clear & curl -s http://localhost:8080/api/v1/pods | grep '"name": "smasher-6fb5c57466-'

const URL = "http://127.0.0.1:8080/"
const PODS = "api/v1/namespaces/default/pods/"
const REPLICAS = "api/v1/namespaces/default/replicas/"

var counts = { "pods": 0, "replicas": 0}

func _ready():
    $HTTPPodRequest.connect("request_completed", self ,"_on_PodRequest_request_completed")
    $HTTPReplicaRequest.connect("request_completed", self ,"_on_ReplicaRequest_request_completed")
    pass

func _on_PodRequest_request_completed(result, response_code, headers, body ):
    var json = JSON.parse(body.get_string_from_utf8()).result
    var cnt = 0
    var items = json.get('items')

    for item in items:
        var metadata = item.get('metadata')
        if 'smasher-6fb5c57466' in metadata.get('name'):
            cnt += 1
    
    counts["pods"] = cnt

func _on_ReplicaRequest_request_completed(result, response_code, headers, body ):
    var json = JSON.parse(body.get_string_from_utf8()).result
    var cnt = 0
    var items = json.get('items')

 #   for item in items:
 #       var metadata = item.get('metadata')
 #       if 'smasher-6fb5c57466' in metadata.get('name'):
 #           cnt += 1
    
    counts["replicas"] = cnt


func _on_Poller_timeout():
    $Connex.set_text('Connecting to '+URL)
 
    var error = $HTTPPodRequest.request(URL+PODS)
    if error != OK:
        $Connex.set_text('Error connecting to '+URL+PODS)
        return
        
    error = $HTTPReplicaRequest.request(URL+REPLICAS)
    if error != OK:
        $Connex.set_text('Error connecting to '+URL+REPLICAS)
        return
        
        
    

func _on_Clock_timeout():
    $Info.set_text(str('Pods: ',counts['pods'],'\n','ReplicaSets: ', counts['replicas']))
