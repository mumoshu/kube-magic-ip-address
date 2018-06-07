# kube-magic-ip-assigner

[DockerHub](https://hub.docker.com/r/mumoshu/kube-magic-ip-assigner/)

`kube-magic-ip-assigner` is a kubernetes sidecar container which runs a nginx udp(tcp coming!) load balancer for collocated pods(which is scheduled in the same node as the pod running this sidecar container) matching user specified pod selector.

It is useful when you'd like to connect pods in the same node e.g. connecting your applicaton pod to a Datadog's dd-agent daemonset pod in the same node without hard-coding of IPs or hostnames or tight-coupling with kubernetes. From your application, just connect `localhost:<port you specify>` and netfiler/iptables will redirect packets to another pods in the same node according to pod selector you've provided.
