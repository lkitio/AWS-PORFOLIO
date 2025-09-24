# Lab 9: AWS CloudFormation

## 🎯 Objective
Deploy the entire customer onboarding infrastructure using Infrastructure as Code principles with AWS CloudFormation.

## 🏦 Business Scenario
Create comprehensive CloudFormation templates that can deploy the entire Chime Bank customer onboarding application infrastructure consistently across different environments.

## 📋 Lab Tasks

### Task 1: Master Template
- Create master template for entire stack
- Configure nested stack architecture
- Implement parameter passing between stacks

### Task 2: Environment Configuration
- Create templates for different environments (dev, staging, prod)
- Implement conditional resource creation
- Configure environment-specific parameters

### Task 3: Deployment Automation
- Create deployment scripts
- Implement stack update procedures
- Set up rollback mechanisms

## 🛠️ Resources Created
- **Master Template**: Orchestrates all infrastructure
- **Nested Templates**: Modular infrastructure components
- **Parameter Files**: Environment-specific configurations
- **Deployment Scripts**: Automated deployment tools

## 🚀 Deployment Instructions
```bash
cd lab-09-cloudformation
./scripts/deploy-full-stack.sh
```

## 🏁 Next Steps
Proceed to [Lab 10: Amazon CloudWatch](../lab-10-cloudwatch/) to implement monitoring and observability.
