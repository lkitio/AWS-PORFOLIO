# Lab 8: Amazon Cognito

## 🎯 Objective
Implement secure user authentication and authorization for the customer onboarding application using Amazon Cognito.

## 🏦 Business Scenario
Set up user authentication system with MFA, password policies, and user management capabilities required for banking applications with proper security controls.

## 📋 Lab Tasks

### Task 1: Create User Pool
- Configure user pool with banking-compliant policies
- Set up MFA requirements
- Configure user attributes and verification

### Task 2: Identity Pool Setup
- Create identity pool for AWS resource access
- Configure authentication providers
- Set up role-based access control

### Task 3: Application Integration
- Configure hosted UI for authentication
- Set up JWT token validation
- Implement user registration flow

## 🛠️ Resources Created
- **User Pool**: Customer authentication
- **Identity Pool**: AWS resource access
- **App Clients**: Application integration
- **User Pool Domain**: Hosted authentication UI

## 🚀 Deployment Instructions
```bash
cd lab-08-cognito
./scripts/setup-cognito.sh
```

## 🏁 Next Steps
Proceed to [Lab 9: AWS CloudFormation](../lab-09-cloudformation/) to implement Infrastructure as Code.
