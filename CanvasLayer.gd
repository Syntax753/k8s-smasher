extends CanvasLayer
# clear & curl -s http://localhost:8080/api/v1/pods | grep '"name": "smasher-6fb5c57466-'

var timer

func _ready():
    pass

func _on_Button_pressed():
    $HTTPRequest.request("http://127.0.0.1:8080/api/v1/namespaces/default/pods/")

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
    var json = JSON.parse(body.get_string_from_utf8()).result
    var cnt = 0
    var items = json.get('items')

    for item in items:
        var metadata = item.get('metadata')
        if 'smasher-6fb5c57466' in metadata.get('name'):
            cnt += 1
    
    print(cnt)

func _on_Poller_timeout():
    print('time                 out')
    pass # Replace with function body.
