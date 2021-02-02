apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: myingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  tls:
  - hosts:
    - test.jv-dev-dev-cluster-4d801e9c87f3c801465049d014041247-0000.eu-gb.containers.appdomain.cloud
    secretName: demo-cert
  rules:
  - host: test.jv-dev-dev-cluster-4d801e9c87f3c801465049d014041247-0000.eu-gb.containers.appdomain.cloud
    http:
      paths:
      - path: /
        backend:
          serviceName: hello-world-svc
          servicePort: 8080