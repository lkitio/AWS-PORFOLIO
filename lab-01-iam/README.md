# Lab 1: AWS Identity and Access Management (IAM)

## 🎯 Objective
Set up secure access controls for the Chime Bank customer onboarding application using AWS IAM best practices.

## 🏦 Business Scenario
As a cloud developer for Chime Bank, you need to establish proper access controls for the customer onboarding application. This includes creating roles for different team members, setting up service accounts for applications, and implementing the principle of least privilege.

## 📋 Lab Tasks

### Task 1: Create IAM Groups and Users
- Create developer group with appropriate permissions
- Create operations group for infrastructure management
- Create service accounts for application components

### Task 2: Implement IAM Roles
- Create EC2 instance roles for application servers
- Create Lambda execution roles for serverless functions
- Create cross-service access roles

### Task 3: Set Up IAM Policies
- Create custom policies for bank-specific operations
- Implement resource-based policies for S3 buckets
- Set up trust policies for cross-account access

## 🛠️ Resources Created

- **IAM Users**: Developer accounts, service accounts
- **IAM Groups**: Developers, Operations, Auditors
- **IAM Roles**: EC2-CustomerOnboarding-Role, Lambda-DataProcessor-Role
- **IAM Policies**: ChimeBankCustomerDataPolicy, OnboardingAppPolicy

## 📁 Files Structure
```
lab-01-iam/
├── README.md
├── cloudformation/
│   ├── iam-users-groups.yaml
│   ├── iam-roles.yaml
│   └── iam-policies.yaml
├── scripts/
│   ├── setup-iam.sh
│   └── validate-permissions.sh
└── docs/
    ├── iam-architecture.md
    └── security-best-practices.md
```

## 🚀 Deployment Instructions

### Prerequisites
- AWS CLI configured with administrator permissions
- CloudFormation CLI access

### Step 1: Deploy IAM Policies
```bash
aws cloudformation create-stack \
  --stack-name chime-bank-iam-policies \
  --template-body file://cloudformation/iam-policies.yaml \
  --capabilities CAPABILITY_IAM
```

### Step 2: Deploy IAM Roles
```bash
aws cloudformation create-stack \
  --stack-name chime-bank-iam-roles \
  --template-body file://cloudformation/iam-roles.yaml \
  --capabilities CAPABILITY_IAM
```

### Step 3: Deploy IAM Users and Groups
```bash
aws cloudformation create-stack \
  --stack-name chime-bank-iam-users \
  --template-body file://cloudformation/iam-users-groups.yaml \
  --capabilities CAPABILITY_IAM
```

## 🔍 Validation Steps

1. **Verify Role Creation**:
   ```bash
   aws iam list-roles --query 'Roles[?contains(RoleName, `ChimeBank`)].RoleName'
   ```

2. **Test Permission Boundaries**:
   ```bash
   ./scripts/validate-permissions.sh
   ```

3. **Check Policy Attachments**:
   ```bash
   aws iam list-attached-role-policies --role-name EC2-CustomerOnboarding-Role
   ```

## 🔒 Security Considerations

- **Principle of Least Privilege**: Each role has minimal required permissions
- **MFA Requirements**: Multi-factor authentication for sensitive operations
- **Password Policies**: Strong password requirements for all users
- **Access Logging**: CloudTrail integration for audit purposes

## 📊 Key Metrics
- Number of IAM users created: 5
- Number of IAM roles created: 4
- Number of custom policies created: 3
- Security best practices implemented: 10+

## 🏁 Next Steps
After completing this lab, proceed to [Lab 2: Amazon VPC](../lab-02-vpc/) to set up the network infrastructure.

## 📚 Additional Resources
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [IAM Policy Language](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_grammar.html)
- [Banking Security on AWS](https://aws.amazon.com/financial-services/security-compliance/)