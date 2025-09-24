# Lab 2: Amazon Virtual Private Cloud (VPC)

## 🎯 Objective
Design and implement secure network infrastructure for the Chime Bank customer onboarding application using Amazon VPC.

## 🏦 Business Scenario
As a cloud developer for Chime Bank, you need to create a secure, scalable network architecture that isolates customer data and ensures compliance with banking regulations. The network must support web applications, databases, and internal services while maintaining strict security boundaries.

## 📋 Lab Tasks

### Task 1: Design VPC Architecture
- Create a VPC with public and private subnets across multiple AZs
- Implement proper CIDR block allocation
- Set up Internet Gateway and NAT Gateways for secure internet access

### Task 2: Configure Security Groups
- Create security groups for web tier, application tier, and database tier
- Implement least privilege access rules
- Configure port restrictions for banking applications

### Task 3: Set Up Network Access Control Lists (NACLs)
- Create custom NACLs for additional security layers
- Configure subnet-level access controls
- Implement defense in depth strategy

### Task 4: Enable VPC Flow Logs
- Configure VPC Flow Logs for network monitoring
- Set up CloudWatch integration for log analysis
- Enable security audit capabilities

## 🛠️ Resources Created

- **VPC**: 1 VPC with /16 CIDR block
- **Subnets**: 6 subnets (2 public, 4 private) across 2 AZs
- **Gateways**: 1 Internet Gateway, 2 NAT Gateways
- **Security Groups**: 4 security groups for different tiers
- **NACLs**: 2 custom Network ACLs
- **Route Tables**: 3 route tables for traffic routing

## 📁 Files Structure
```
lab-02-vpc/
├── README.md
├── cloudformation/
│   ├── vpc-infrastructure.yaml
│   ├── security-groups.yaml
│   └── nacls-flowlogs.yaml
├── scripts/
│   ├── setup-vpc.sh
│   └── validate-connectivity.sh
└── docs/
    ├── network-architecture.md
    └── security-design.md
```

## 🏗️ Network Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Chime Bank VPC (10.0.0.0/16)            │
├─────────────────────────────────────────────────────────────┤
│  AZ-1 (us-west-2a)           │  AZ-2 (us-west-2b)          │
├───────────────────────────────┼──────────────────────────────┤
│ Public Subnet A (10.0.1.0/24)│ Public Subnet B (10.0.2.0/24)│
│ - Web Load Balancers         │ - Web Load Balancers         │
│ - NAT Gateway A              │ - NAT Gateway B              │
├───────────────────────────────┼──────────────────────────────┤
│ Private Subnet A (10.0.3.0/24)│ Private Subnet B (10.0.4.0/24)│   
│ - Application Servers        │ - Application Servers        │
│ - Lambda Functions           │ - Lambda Functions           │
├───────────────────────────────┼──────────────────────────────┤
│ Database Subnet A (10.0.5.0/24)│ Database Subnet B (10.0.6.0/24)│
│ - RDS Primary                │ - RDS Replica                │
│ - ElastiCache                │ - ElastiCache                │
└───────────────────────────────┴──────────────────────────────┘
```

## 🚀 Deployment Instructions

### Prerequisites
- AWS CLI configured with appropriate permissions
- Completed Lab 1 (IAM setup)

### Step 1: Deploy VPC Infrastructure
```bash
cd lab-02-vpc
./scripts/setup-vpc.sh
```

### Alternative: Manual CloudFormation Deployment
```bash
aws cloudformation create-stack \
  --stack-name chime-bank-vpc-infrastructure \
  --template-body file://cloudformation/vpc-infrastructure.yaml \
  --parameters ParameterKey=EnvironmentName,ParameterValue=Development
```

### Step 2: Deploy Security Groups
```bash
aws cloudformation create-stack \
  --stack-name chime-bank-security-groups \
  --template-body file://cloudformation/security-groups.yaml \
  --parameters ParameterKey=VpcId,ParameterValue=<VPC_ID>
```

### Step 3: Configure NACLs and Flow Logs
```bash
aws cloudformation create-stack \
  --stack-name chime-bank-nacls-flowlogs \
  --template-body file://cloudformation/nacls-flowlogs.yaml \
  --parameters ParameterKey=VpcId,ParameterValue=<VPC_ID>
```

## 🔍 Validation Steps

1. **Verify VPC Creation**:
   ```bash
   aws ec2 describe-vpcs --filters Name=tag:Name,Values=ChimeBank-VPC
   ```

2. **Test Connectivity**:
   ```bash
   ./scripts/validate-connectivity.sh
   ```

3. **Check Security Group Rules**:
   ```bash
   aws ec2 describe-security-groups --group-names ChimeBank-Web-SG
   ```

4. **Verify Flow Logs**:
   ```bash
   aws logs describe-log-groups --log-group-name-prefix VPCFlowLogs
   ```

## 🔒 Security Features

- **Network Segmentation**: Three-tier architecture with isolated subnets
- **Security Groups**: Stateful firewall rules at instance level
- **NACLs**: Stateless firewall rules at subnet level
- **VPC Flow Logs**: Network traffic monitoring and analysis
- **NAT Gateways**: Secure outbound internet access for private resources
- **Private Subnets**: Database and application tiers isolated from internet

## 📊 Key Metrics
- Availability Zones: 2 (for high availability)
- Public Subnets: 2 (for load balancers and NAT gateways)
- Private Subnets: 4 (for applications and databases)
- Security Groups: 4 (web, app, database, management)
- Network ACLs: 2 (public and private subnet controls)

## 💰 Cost Optimization
- **NAT Gateway**: Use NAT instances for dev environments to reduce costs
- **Flow Logs**: Configure sampling for cost-effective monitoring
- **Elastic IPs**: Minimize usage to avoid charges
- **Data Transfer**: Route traffic efficiently to minimize cross-AZ charges

## 🏁 Next Steps
After completing this lab, proceed to [Lab 3: Amazon EC2](../lab-03-ec2/) to deploy the application servers in your newly created VPC.

## 📚 Additional Resources
- [VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
- [Banking Architecture on AWS](https://aws.amazon.com/architecture/banking/)
- [Network Security Design Patterns](https://aws.amazon.com/architecture/security-identity-compliance/)