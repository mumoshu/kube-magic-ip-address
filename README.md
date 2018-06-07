# kube-magic-ip-assigner

[DockerHub](https://hub.docker.com/r/mumoshu/kube-magic-ip-assigner/)

`kube-magic-ip-assigner` is a Kubernetes daemonset to create magic IPs. It periodically polls the Kubernetes API to find collocated pods(which is scheduled in the same node as the pod running kube-magic-ip-assigner) matching user specified pod selector. The colocated pods are assigned the magic IP(for example `169.254.210.210`) which can be used by other pods to connect collocated pods.

It is useful when you'd like to connect pods in the same node e.g. connecting your applicaton pod to a Datadog's dd-agent daemonset pod in the same node without hard-coding of IPs or hostnames or tight-coupling with kubernetes. From your application, just connect `localhost:<port you specify>` and netfiler/iptables will redirect packets to another pods in the same node according to pod selector you've provided.
