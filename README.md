# Automated Compliance Enforcement for AWS Environments

This project implements a **Compliance-as-Code (CaC)** framework to automate security compliance checks and remediation across AWS services, using **AWS Config**, **Amazon EventBridge**, **AWS Lambda**, **AWS CodeBuild**, and **Ansible playbooks**.  

The system continuously monitors critical AWS resources (IAM, S3, RDS, and DynamoDB) against **CIS Benchmarks** and **NIST security controls**, and automatically remediates non-compliance issues in near real-time.

---

## Features
- **Continuous Compliance Monitoring** with AWS Config rules.
- **Event-Driven Automation** using Amazon EventBridge.
- **Orchestration via Lambda** for selecting remediation workflows.
- **Automated Remediation** using Ansible playbooks and Bash scripts stored in Amazon S3.
- **Execution Environment** using AWS CodeBuild for remediation tasks.
- **Centralized Logging & Auditing** for compliance events and remediation actions.
- Supports **IAM, S3, RDS, and DynamoDB** compliance controls.

---

## Architecture Overview
The high-level architecture follows an automated compliance pipeline:

1. **AWS Config** evaluates resources against CIS/NIST benchmark rules.  
2. **EventBridge** captures non-compliance events and routes them.  
3. **AWS Lambda** identifies the relevant playbook/script.  
4. **AWS CodeBuild** executes **Ansible playbooks** or **Bash scripts** from S3.  
5. **Remediation actions** are applied to bring resources back into compliance.  
6. **Logs** are stored for auditing and reporting.  

---

## Services & Tools Used
- **AWS Config** – Compliance monitoring  
- **Amazon EventBridge** – Event-driven automation  
- **AWS Lambda** – Workflow orchestration  
- **AWS CodeBuild** – Execution of remediation playbooks  
- **Amazon S3** – Storage for playbooks, scripts, and logs  
- **Ansible** – Compliance-as-Code remediation  
- **IAM Roles & Policies** – Secure automation and RBAC  

---

## Compliance Rules Implemented
| **Control ID** | **Control / Rule**                          | **Resource Type**   | **AWS Config Rule**                        |
|----------------|----------------------------------------------|---------------------|--------------------------------------------|
| 1.17           | Ensure IAM users are assigned to a group     | IAM Users           | `iam-user-group-membership-check`          |
| 1.18           | Ensure IAM groups have users                 | IAM Groups          | `iam-group-has-users`                      |
| 2.5            | Ensure S3 Buckets have versioning enabled    | S3 Buckets          | `s3-bucket-versioning-enabled`             |
| AU-7           | RDS must not be publicly accessible          | RDS Instances       | `rds-instance-public-access-check`         |
| AU-11          | Ensure RDS deletion protection is enabled    | RDS Instances       | `rds-instance-deletion-protection-enabled` |
| AU-12          | Ensure RDS logging is enabled                | RDS Instances       | `rds-logging-enabled`                      |
| SC-28          | DynamoDB encryption at rest                  | DynamoDB Tables     | `dynamodb-table-encryption-enabled`        |

---

## Testing & Validation
- Misconfigurations were deliberately introduced (e.g., public RDS instance, S3 without versioning, IAM users without groups).  
- AWS Config detected violations in real time.  
- EventBridge triggered Lambda → CodeBuild pipelines.  
- Ansible playbooks remediated issues automatically.  
- Validation was done using **AWS Config Dashboard** and **CLI tools**.  

---

## Results
- Compliance drift detected in **seconds**.  
- Automated remediation applied consistently across all resources.  
- Reduced **manual intervention** and improved **governance visibility**.  
- Aligns AWS resources with **CIS Benchmarks** and **NIST security guidelines**.  

---

## Future Scope
- Extend coverage to more AWS services (CloudTrail, VPC, CloudFront, EFS, SNS, SQS).  
- Integrate with **AWS Security Hub** for centralized findings.  
- Multi-cloud support (Azure, GCP).  
- Real-time dashboards and alerts (CloudWatch, Grafana, Slack).  
- Integration into CI/CD pipelines for **DevSecOps adoption**.  

---

## 👨‍💻 Author
**Charles Domnick** 
