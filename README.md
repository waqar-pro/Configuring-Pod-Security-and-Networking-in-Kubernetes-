# 🔐 Kubernetes Pod Security & Networking Lab

A hands-on lab covering Pod Security Admission (PSA) and Network Policies in Kubernetes.

---

## 📋 Lab Overview

| Topic | Details |
|-------|---------|
| **Lab Name** | Configuring Pod Security and Networking |
| **Tools** | Kubernetes, Minikube, kubectl |
| **Tasks** | 6 Tasks |
| **Level** | Intermediate |

---

## ✅ What I Implemented

### Task 1 — Pod Security Admission (PSA)
- Configured **Baseline** policy — blocks privileged containers
- Configured **Restricted** policy — non-root users, read-only filesystem
- Tested enforcement — privileged pod was **automatically rejected**

### Task 2 — Network Policy Environment
- Created 3 namespaces: `frontend`, `backend`, `database`
- Deployed nginx, httpd, and mysql applications

### Task 3 — Connectivity Test (Before Policies)
- Verified all pods could communicate freely
- Documented baseline connectivity

### Task 4 — Network Policies Applied
- Default deny all traffic to database
- Specific allow rules configured

### Task 5 — Connectivity Test (After Policies)
- Verified allowed connections work
- Verified blocked connections are enforced

### Task 6 — Advanced Egress Policy
- Backend restricted to only communicate with database

---

## 🌐 Network Policy Rules

```
Frontend  ──────────────►  Backend   ✅ Allowed
Backend   ──────────────►  Database  ✅ Allowed
Frontend  ──────────────►  Database  ❌ BLOCKED
Default   ──────────────►  Database  ❌ BLOCKED
```

---

## 🛠️ Key Commands

### Pod Security
```bash
# Apply Baseline PSA label
kubectl label namespace security-demo \
  pod-security.kubernetes.io/enforce=baseline \
  pod-security.kubernetes.io/audit=baseline \
  pod-security.kubernetes.io/warn=baseline

# Apply Restricted PSA label
kubectl label namespace restricted-demo \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/audit=restricted \
  pod-security.kubernetes.io/warn=restricted

# Test — this should be REJECTED
kubectl apply -f baseline-rejected-pod.yaml
```

### Network Policy
```bash
# Default deny all
kubectl apply -f database-default-deny.yaml

# Allow backend to database
kubectl apply -f allow-backend-to-database.yaml

# Allow frontend to backend
kubectl apply -f allow-frontend-to-backend.yaml

# Verify policies
kubectl get networkpolicy -A
```

### Connectivity Testing
```bash
# Get frontend pod
FRONTEND_POD=$(kubectl get pods -n frontend \
  -l app=frontend \
  -o jsonpath='{.items[0].metadata.name}')

# Test frontend to backend (should work)
kubectl exec -n frontend $FRONTEND_POD -- \
  curl -s --connect-timeout 5 \
  backend-service.backend.svc.cluster.local

# Test frontend to database (should be blocked)
kubectl exec -n frontend $FRONTEND_POD -- \
  timeout 5 bash -c \
  "</dev/tcp/database-service.database.svc.cluster.local/3306" \
  && echo "Connected" || echo "Blocked!"
```

---

## 📁 File Structure

```
k8s-lab/
├── README.md
├── pod-security/
│   ├── baseline-allowed-pod.yaml
│   ├── baseline-rejected-pod.yaml
│   └── restricted-compliant-pod.yaml
└── network-policy/
    ├── frontend-app.yaml
    ├── backend-app.yaml
    ├── database-app.yaml
    ├── database-default-deny.yaml
    ├── allow-backend-to-database.yaml
    ├── allow-database-dns.yaml
    ├── allow-frontend-to-backend.yaml
    └── backend-egress-policy.yaml
```

---

## 🧹 Cleanup Commands

```bash
# Delete all lab namespaces
kubectl delete namespace security-demo
kubectl delete namespace restricted-demo
kubectl delete namespace frontend
kubectl delete namespace backend
kubectl delete namespace database

# Delete local files
rm -f *.yaml
```

---

## ✅ Results

| Test | Before Policy | After Policy |
|------|:---:|:---:|
| Frontend → Backend | ✅ Connected | ✅ Connected |
| Backend → Database | ✅ Connected | ✅ Connected |
| Frontend → Database | ✅ Connected | ❌ Blocked |
| Default → Database | ✅ Connected | ❌ Blocked |
| Privileged Pod | ✅ Created | ❌ Rejected |

---

## 💡 Key Takeaway

> Security in Kubernetes is about **layers**:
> - **PSA** controls *what* a pod can do
> - **Network Policy** controls *who* can talk to *whom*
> - Both together = a production-ready secure cluster

---

## 🏷️ Tags

`Kubernetes` `DevOps` `Security` `NetworkPolicy` `PodSecurity` `CloudNative` `AlNafi`
