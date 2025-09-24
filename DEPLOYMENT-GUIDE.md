# Chime Bank Customer Onboarding - Deployment Guide

## 🚀 Quick Start

This guide will help you deploy the complete Chime Bank Customer Onboarding application portfolio across AWS services.

## ⚡ One-Click Deployment

For a complete deployment of all services:

```bash
# Clone the repository
git clone <repository-url>
cd AWS-PORFOLIO

# Run the master deployment script
./deploy-full-portfolio.sh
```

## 📋 Prerequisites

### Required Tools
- AWS CLI v2.x installed and configured
- AWS Account with appropriate permissions
- Bash shell (Linux/macOS/WSL)
- Git

### AWS Permissions Required
Your AWS user/role must have permissions for:
- CloudFormation stack operations
- IAM role and policy management
- VPC and EC2 operations
- RDS and S3 operations
- Lambda and API Gateway operations
- Cognito and CloudWatch operations

### Initial AWS Configuration
```bash
# Configure AWS CLI
aws configure

# Verify configuration
aws sts get-caller-identity
```

## 🎯 Deployment Options

### Option 1: Complete Portfolio Deployment
Deploy all 10 labs in sequence:
```bash
./scripts/deploy-complete-portfolio.sh
```

### Option 2: Individual Lab Deployment
Deploy labs individually as needed:
```bash
# Lab 1: IAM
cd lab-01-iam && ./scripts/setup-iam.sh

# Lab 2: VPC
cd lab-02-vpc && ./scripts/setup-vpc.sh

# Continue with remaining labs...
```

### Option 3: CloudFormation Master Stack
Deploy using the master CloudFormation template:
```bash
aws cloudformation create-stack \
  --stack-name chime-bank-complete \
  --template-body file://lab-09-cloudformation/master-template.yaml \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=Environment,ParameterValue=Development
```

## 📚 Lab-by-Lab Deployment Guide

### Lab 1: IAM Setup (Required First)
```bash
cd lab-01-iam
./scripts/setup-iam.sh

# Verify deployment
aws iam list-roles --query 'Roles[?contains(RoleName, `ChimeBank`)].RoleName'
```

**Estimated Time**: 5 minutes  
**Dependencies**: None  
**Outputs**: IAM Roles and Policies ARNs

### Lab 2: VPC Infrastructure (Required Second)
```bash
cd lab-02-vpc
./scripts/setup-vpc.sh

# Verify deployment
aws ec2 describe-vpcs --filters Name=tag:Name,Values=ChimeBank-VPC
```

**Estimated Time**: 10 minutes  
**Dependencies**: None  
**Outputs**: VPC ID, Subnet IDs, Security Group IDs

### Lab 3: EC2 Application Servers
```bash
cd lab-03-ec2
./scripts/setup-ec2.sh

# Verify deployment
aws ec2 describe-instances --filters Name=tag:Purpose,Values=CustomerOnboarding
```

**Estimated Time**: 15 minutes  
**Dependencies**: Lab 1 (IAM), Lab 2 (VPC)  
**Outputs**: Load Balancer DNS, Auto Scaling Group ARN

### Lab 4: RDS Database
```bash
cd lab-04-rds
./scripts/setup-rds.sh

# Verify deployment
aws rds describe-db-instances --query 'DBInstances[?contains(DBInstanceIdentifier, `chime-bank`)].DBInstanceStatus'
```

**Estimated Time**: 20 minutes  
**Dependencies**: Lab 2 (VPC)  
**Outputs**: RDS Endpoint, Database Connection String

### Lab 5: S3 Storage
```bash
cd lab-05-s3
./scripts/setup-s3.sh

# Verify deployment
aws s3 ls | grep chime-bank
```

**Estimated Time**: 5 minutes  
**Dependencies**: Lab 1 (IAM)  
**Outputs**: Bucket Names, CloudFront Distribution URL

### Lab 6: Lambda Functions
```bash
cd lab-06-lambda
./scripts/setup-lambda.sh

# Verify deployment
aws lambda list-functions --query 'Functions[?contains(FunctionName, `chime-bank`)].FunctionName'
```

**Estimated Time**: 10 minutes  
**Dependencies**: Lab 1 (IAM), Lab 2 (VPC), Lab 5 (S3)  
**Outputs**: Lambda Function ARNs

### Lab 7: API Gateway
```bash
cd lab-07-api-gateway
./scripts/setup-api-gateway.sh

# Verify deployment
aws apigateway get-rest-apis --query 'items[?contains(name, `chime-bank`)].name'
```

**Estimated Time**: 10 minutes  
**Dependencies**: Lab 6 (Lambda)  
**Outputs**: API Gateway URL, API Keys

### Lab 8: Cognito Authentication
```bash
cd lab-08-cognito
./scripts/setup-cognito.sh

# Verify deployment
aws cognito-idp list-user-pools --max-results 20 --query 'UserPools[?contains(Name, `ChimeBank`)].Name'
```

**Estimated Time**: 10 minutes  
**Dependencies**: None  
**Outputs**: User Pool ID, App Client ID

### Lab 9: CloudFormation IaC
```bash
cd lab-09-cloudformation
./scripts/deploy-full-stack.sh

# This deploys all infrastructure as code
```

**Estimated Time**: 45 minutes  
**Dependencies**: Replaces individual lab deployments  
**Outputs**: All infrastructure resources

### Lab 10: CloudWatch Monitoring
```bash
cd lab-10-cloudwatch
./scripts/setup-monitoring.sh

# Verify deployment
aws cloudwatch list-dashboards --query 'DashboardEntries[?contains(DashboardName, `ChimeBank`)].DashboardName'
```

**Estimated Time**: 15 minutes  
**Dependencies**: All previous labs  
**Outputs**: Dashboard URLs, Alarm ARNs

## ⚙️ Configuration Options

### Environment-Specific Deployments

#### Development Environment
```bash
export ENVIRONMENT=Development
export INSTANCE_TYPE=t3.micro
export RDS_INSTANCE_CLASS=db.t3.micro
```

#### Staging Environment
```bash
export ENVIRONMENT=Staging
export INSTANCE_TYPE=t3.small
export RDS_INSTANCE_CLASS=db.t3.small
```

#### Production Environment
```bash
export ENVIRONMENT=Production
export INSTANCE_TYPE=t3.medium
export RDS_INSTANCE_CLASS=db.t3.medium
```

### Custom Parameters
Each lab accepts custom parameters:

```bash
# Example: Custom VPC CIDR
./scripts/setup-vpc.sh --vpc-cidr 172.16.0.0/16

# Example: Custom RDS instance size
./scripts/setup-rds.sh --instance-class db.t3.large

# Example: Custom Lambda memory
./scripts/setup-lambda.sh --memory-size 512
```

## 🔍 Validation and Testing

### Automated Validation
```bash
# Run validation scripts after deployment
./scripts/validate-deployment.sh

# Test individual components
./scripts/test-api-endpoints.sh
./scripts/test-database-connectivity.sh
./scripts/test-lambda-functions.sh
```

### Manual Validation Checklist

#### Infrastructure Validation
- [ ] VPC created with correct CIDR blocks
- [ ] EC2 instances running in private subnets
- [ ] RDS database accessible from application tier
- [ ] Load balancer responding to health checks
- [ ] Auto Scaling Group configured correctly

#### Security Validation
- [ ] Security groups allow only required traffic
- [ ] IAM roles have minimal required permissions
- [ ] S3 buckets have proper access policies
- [ ] Database encryption enabled
- [ ] VPC Flow Logs activated

#### Application Validation
- [ ] API Gateway endpoints responding
- [ ] Lambda functions executing successfully
- [ ] Cognito user authentication working
- [ ] Document upload to S3 functional
- [ ] Database connections established

#### Monitoring Validation
- [ ] CloudWatch dashboards displaying metrics
- [ ] Alarms configured and functional
- [ ] Log groups receiving application logs
- [ ] SNS notifications working

## 🧹 Cleanup

### Complete Cleanup
```bash
# Remove all resources
./scripts/cleanup-complete-portfolio.sh
```

### Individual Lab Cleanup
```bash
# Clean up specific labs
cd lab-01-iam && ./scripts/cleanup-iam.sh
cd lab-02-vpc && ./scripts/cleanup-vpc.sh
# etc.
```

### Manual CloudFormation Cleanup
```bash
# Delete stacks in reverse order
aws cloudformation delete-stack --stack-name chime-bank-monitoring
aws cloudformation delete-stack --stack-name chime-bank-lambda
aws cloudformation delete-stack --stack-name chime-bank-rds
aws cloudformation delete-stack --stack-name chime-bank-ec2
aws cloudformation delete-stack --stack-name chime-bank-vpc
aws cloudformation delete-stack --stack-name chime-bank-iam
```

## 🔧 Troubleshooting

### Common Issues

#### CloudFormation Stack Creation Failed
```bash
# Check stack events
aws cloudformation describe-stack-events --stack-name <stack-name>

# Check stack resources
aws cloudformation describe-stack-resources --stack-name <stack-name>
```

#### IAM Permission Errors
```bash
# Check current permissions
aws sts get-caller-identity
aws iam simulate-principal-policy --policy-source-arn <user-arn> --action-names <action>
```

#### VPC Resource Limits
```bash
# Check VPC limits
aws ec2 describe-account-attributes --attribute-names supported-platforms
aws service-quotas list-service-quotas --service-code ec2
```

#### RDS Connection Issues
```bash
# Check security groups
aws ec2 describe-security-groups --group-ids <sg-id>

# Test database connectivity
nc -z <rds-endpoint> 5432
```

### Support Resources
- AWS Documentation: https://docs.aws.amazon.com/
- AWS Support: https://aws.amazon.com/support/
- Community Forums: https://forums.aws.amazon.com/

## 📊 Cost Estimation

### Development Environment
- **Monthly Cost**: ~$50-100
- **EC2 Instances**: t3.micro (free tier eligible)
- **RDS**: db.t3.micro (free tier eligible)
- **Data Transfer**: Minimal charges

### Production Environment
- **Monthly Cost**: ~$200-500
- **EC2 Instances**: t3.medium with Auto Scaling
- **RDS**: db.t3.medium with Multi-AZ
- **Additional Services**: NAT Gateway, Load Balancer charges

### Cost Optimization Tips
- Use AWS Free Tier resources for development
- Stop non-production resources when not in use
- Implement lifecycle policies for S3 storage
- Monitor usage with AWS Cost Explorer

## 🔄 Updates and Maintenance

### Regular Maintenance Tasks
- Update AMIs and patch EC2 instances
- Review and rotate IAM access keys
- Monitor and analyze CloudWatch logs
- Update Lambda function dependencies
- Review and optimize database performance

### Version Control
All infrastructure changes should be:
- Committed to version control
- Tested in development environment first
- Deployed using CloudFormation templates
- Documented in change logs

---

**Total Deployment Time**: ~2-3 hours for complete portfolio  
**Recommended Approach**: Start with individual labs to understand each component, then use the master deployment for production.