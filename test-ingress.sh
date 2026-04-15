#!/bin/bash
echo "=== Ingress Testing Script ==="
echo

echo "1. HTTP to HTTPS redirect:"
curl -s -o /dev/null -w "HTTP Status: %{http_code}, Redirect: %{redirect_url}\n" http://myapps.local/app1
echo

echo "2. HTTPS app1:"
curl -k -s https://myapps.local/app1 | grep -o "<title>.*</title>"
echo

echo "3. HTTPS app2:"
curl -k -s https://myapps.local/app2 | grep -o "<title>.*</title>"
echo

echo "4. API subdomain:"
curl -k -s https://api.myapps.local/ | grep -o "<title>.*</title>"
echo

echo "5. SSL Certificate:"
echo | openssl s_client -servername myapps.local -connect $(minikube ip):443 2>/dev/null | openssl x509 -noout -subject
echo

echo "=== Testing Complete ==="
