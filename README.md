# Self-Managed Kubernetes Cluster on AWS (kubeadm)

## 📌 Problem Statement

The goal of this project is to create a **self-managed, highly available Kubernetes cluster** on AWS using `kubeadm`.  
Instead of using **EKS (Elastic Kubernetes Service)**, we will replicate its functionality step by step using AWS building blocks such as **EC2 instances, Auto Scaling Groups (ASG), and Load Balancers**.

![GitOps Workflow](Assets/Kubernetescluster.jpg)

The cluster will be deployed across **multiple Availability Zones (AZs)** to achieve high availability.  
If a node fails, a new one will be automatically created by the Auto Scaling Group.  

This project is divided into phases:

1. **Phase 1 (Current Scope):**  
   - Build a base image for Kubernetes nodes.  
   - Provision infrastructure using Terraform.  
   - Bootstrap the first control plane node.  
   - Scale control plane nodes with ASG.  
   - Add worker nodes and join them to the cluster.  

2. **Future Phases (Planned Enhancements):**  
   - Add OIDC-based authentication.  
   - Deploy applications on the cluster.  
   - Integrate external **Cloud Controller Manager (CCM)** and **Container Storage Interface (CSI)** to enable persistent volumes (PV) and persistent volume claims (PVC).  

---

## 🚀 Step 1: Create Base Image for Nodes

The first step is to create a **custom Amazon Machine Image (AMI)** that will serve as the base image for all control plane and worker nodes.  
This image will have all the required software pre-installed to run Kubernetes components.  

- **Tools Used:**  
  - **Packer** → to automate the image creation process.  
  - **Jenkins** → to build and manage the image creation pipeline.  

This ensures that every node in the cluster starts with a consistent and pre-configured environment.

---

## 🚀 Step 2: Provision Infrastructure with Terraform

In the next step, Terraform will be used to define and provision the complete infrastructure for the Kubernetes cluster.

### Infrastructure Details:
- **VPC Setup:**  
  - Private VPC spanning **3 Availability Zones**.  
  - Each AZ will have **public** and **private** subnets.

- **Networking & Load Balancing:**  
  - A **Network Load Balancer (NLB)** will be deployed to balance traffic between control plane nodes.  
  - Public subnets will provide controlled access for external communication.  
  - Private subnets will host most cluster nodes for security.

- **Control Plane Setup:**  
  - Initially, one control plane node will be created using a standard EC2 resource.  
  - After bootstrapping the cluster, remaining control plane nodes will be created using **Auto Scaling Groups (ASG)** for high availability.

- **Worker Nodes Setup:**  
  - Once the control plane is established, worker nodes will be provisioned.  
  - These worker nodes will be attached to the cluster to run workloads.

---

## 🔮 Next Steps

Once the cluster is successfully created, the following enhancements will be added in future phases:

- OIDC-based authentication layer.  
- Application hosting on the cluster.  
- Integration with external **CCM** and **CSI** for persistent storage management.  

---
