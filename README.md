# High Availability Kubernetes on AWS with Terraform

This project demonstrates how to design, provision, and manage a **highly-available Kubernetes cluster** on raw IaaS (AWS EC2, networking, storage, and load balancers) using **Terraform**.  
The cluster is bootstrapped with **kubeadm** and configured to run with **containerd** as the container runtime.

No managed Kubernetes services (EKS, AKS, GKE) or turnkey tools (kOps, RKE, etc.) are used.  
The goal is **end-to-end Infrastructure as Code** — one `terraform apply` to create everything, and one `terraform destroy` to clean it up.

---

## 🚀 Features

- Automated provisioning with **Terraform** (Idempotent).
- AWS VPC spanning **3 Availability Zones**.
- **3 Control Plane Nodes** (stacked etcd) behind a cloud Load Balancer.
- **2+ Worker Nodes** distributed across zones.
- **Secure networking**: restricted SSH, NAT Gateway for egress.
- Kubernetes bootstrapped with:
  - `containerd`
  - `kubeadm`, `kubelet`, and `kubectl`
  - **CNI Plugin**: Calico (can be swapped with Cilium)
- Outputs:
  - API server endpoint
  - kubeconfig path
  - Ingress address
  - App URL

---
             │ kubelet+    │     │ kubelet+    │
             │ containerd  │     │ containerd  │
             └─────────────┘     └─────────────┘
