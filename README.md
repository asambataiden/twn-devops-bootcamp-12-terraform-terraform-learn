# Capstone 02 — Automate Kubernetes Deployment

**TechWorld with Nana · DevOps Bootcamp · Capstone 02**

## Assignment and architecture

The project combines **Terraform infrastructure provisioning** with **Ansible application deployment**.

```text
Terraform source (this branch)
  -> AWS VPC: public/private subnets + NAT gateway
  -> Amazon EKS cluster: myapp-eks-cluster
  -> EKS managed node group: dev
         |
         | approved kubeconfig / Kubernetes API permissions
         v
Ansible source (linked separate branch)
  -> create namespace my-app
  -> apply Nginx Deployment (1 replica)
  -> apply nginx-service (LoadBalancer)
```

## What did I build?

I developed Terraform configuration for an Amazon EKS cluster named `myapp-eks-cluster` in `eu-north-1`. The configuration uses the community Terraform EKS module, an AWS VPC module with public and private subnets, a NAT gateway and an EKS managed node group. On a separate Ansible feature branch, I created a playbook that uses Kubernetes modules to create namespace `my-app`, deploy an Nginx application and expose it using a Kubernetes LoadBalancer Service.

This project demonstrates how Terraform can describe cloud infrastructure while Ansible can automate Kubernetes application resources. The two implementations are committed in separate original course repositories and are linked below.

**Verification boundary:** The code has been inspected, but this submission does **not** yet include verified matching Terraform apply output, Ansible task results, Kubernetes workload readiness or HTTP availability. These runtime milestones must not be described as completed without evidence. The EKS cluster from Capstone 01 is a different cluster and cannot be substituted as proof.

## What did I learn?

I learned how Terraform modules define cloud networking, EKS clusters and managed node groups; why subnet placement and node sizing matter; and how Ansible's Kubernetes integration can create namespaces and deploy Kubernetes manifests declaratively. I also learned to distinguish infrastructure provisioning from application deployment, keep kubeconfig and cloud credentials outside Git, verify the target AWS account/cluster before changes, and use explicit acceptance checks rather than infer deployment success from existing source files.

Reviewing the implementation highlighted improvements needed for production, including immutable Nginx image selection, SSH host-key verification, endpoint/access restrictions, Kubernetes workload health checks, least-privilege identity management and deliberate cost controls.

## Exact source branches

**Terraform/EKS (this submission entry point):**  
https://github.com/asambataiden/twn-devops-bootcamp-12-terraform-terraform-learn/tree/feature/project-14-ansible-eks-k8s-deploy-to-eks-with-terraform

**Ansible/Kubernetes companion implementation:**  
https://github.com/asambataiden/twn-devops-bootcamp-15-ansible-deploy-node-app/tree/feature/project-14-ansible-inventory-deploy-to-eks-k8s

### Files to review

**This Terraform branch**
- [EKS cluster configuration](eks-cluster.tf)
- [VPC and networking configuration](vpc.tf)
- [AWS provider constraint](providers.tf)

**Ansible branch**
- [Deployment playbook](https://github.com/asambataiden/twn-devops-bootcamp-15-ansible-deploy-node-app/blob/feature/project-14-ansible-inventory-deploy-to-eks-k8s/deploy-to-k8s.yaml)
- [Deployment variables](https://github.com/asambataiden/twn-devops-bootcamp-15-ansible-deploy-node-app/blob/feature/project-14-ansible-inventory-deploy-to-eks-k8s/k8s-vars.yaml)
- [Nginx manifests](https://github.com/asambataiden/twn-devops-bootcamp-15-ansible-deploy-node-app/blob/feature/project-14-ansible-inventory-deploy-to-eks-k8s/nginx-config.yaml)

## How to review without changing infrastructure

Prerequisites: authorized AWS access, Terraform and a checked-out copy of this branch. Inspect existing variable definitions and provide approved input values; do not assume the current account contains a managed cluster named `myapp-eks-cluster`.

```bash
git status --short --branch
git rev-parse HEAD
terraform fmt -check
terraform validate  # requires provider initialization
aws sts get-caller-identity
```

`terraform init` may download providers/modules and configure a backend; inspect its configuration and target credentials before use. A `terraform plan` refreshes infrastructure state and can propose billable resources. **Do not run `terraform apply` or destroy without explicit approval and an operating cost plan.**

For Ansible, inspect the target cluster and its kubeconfig, then syntax-check the playbook in a separately configured working copy. Do not execute its resource-changing playbook against an unverified cluster.

## Security, costs and known limitations

- EKS control-plane charges, NAT gateway charges, worker nodes and an AWS LoadBalancer can accrue costs while running.
- Three `t3.micro` workers are small for many EKS workloads; validate actual Kubernetes and add-on capacity before deployment.
- Terraform enables a public EKS endpoint and grants cluster creator administrator access. Restrict these for appropriate environments.
- The companion manifest uses `nginx:latest`, which is mutable. Pin a vetted image version or digest before reproducible deployments.
- The Ansible repository currently has `host_key_checking = False`; this should not be used as a general security default.
- Deployment code uses a local kubeconfig path. Never commit kubeconfig or AWS secrets.
- This branch does not on its own contain the Ansible implementation, so review both branch links.

## Final acceptance evidence checklist

- [x] Terraform EKS and VPC code inspected
- [x] Ansible namespace and Nginx deployment code inspected
- [x] Cross-repository links and submission Q&A documented
- [ ] Terraform provisioning evidence for the intended cluster
- [ ] Ansible execution output and task summary
- [ ] Deployment/pod readiness in namespace `my-app`
- [ ] Service exposure and application HTTP response
- [ ] Terraform state ownership, cleanup and incurred-cost review

**Submission note:** This branch is a single navigational link to both source implementations. It is not yet proof of an independently verified end-to-end deployment.
