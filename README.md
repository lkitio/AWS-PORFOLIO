# AWS Portfolio - Chime Bank Customer Onboarding Application

This portfolio demonstrates a comprehensive cloud solution for Chime Bank's customer onboarding application built on AWS. The portfolio consists of 10 hands-on labs that showcase different AWS services and architectural patterns used in building a secure, scalable, and robust customer onboarding system.

## 🏗️ Architecture Overview

The customer onboarding application handles the significant exchange of information between Chime Bank and its customers during the account creation process. The solution leverages multiple AWS services to ensure security, scalability, and reliability.

## 📚 Labs Structure

This repository contains 10 individual labs, each focusing on specific AWS services and components:

### [Lab 1: AWS Identity and Access Management (IAM)](./lab-01-iam/)
- **Focus**: Security foundations and access control
- **Services**: AWS IAM, IAM Roles, Policies
- **Scenario**: Set up secure access controls for the banking application

### [Lab 2: Amazon Virtual Private Cloud (VPC)](./lab-02-vpc/)
- **Focus**: Network infrastructure and security
- **Services**: Amazon VPC, Subnets, Security Groups, NACLs
- **Scenario**: Design secure network architecture for customer data

### [Lab 3: Amazon Elastic Compute Cloud (EC2)](./lab-03-ec2/)
- **Focus**: Application hosting and compute resources
- **Services**: Amazon EC2, Auto Scaling Groups, Load Balancers
- **Scenario**: Deploy scalable application servers

### [Lab 4: Amazon Relational Database Service (RDS)](./lab-04-rds/)
- **Focus**: Database management and customer data storage
- **Services**: Amazon RDS, RDS Multi-AZ, Read Replicas
- **Scenario**: Set up secure and highly available customer database

### [Lab 5: Amazon Simple Storage Service (S3)](./lab-05-s3/)
- **Focus**: Document and media storage
- **Services**: Amazon S3, S3 Encryption, S3 Lifecycle Policies
- **Scenario**: Store customer documents and application assets

### [Lab 6: AWS Lambda](./lab-06-lambda/)
- **Focus**: Serverless computing and data processing
- **Services**: AWS Lambda, Lambda Layers, EventBridge
- **Scenario**: Process customer onboarding workflows serverlessly

### [Lab 7: Amazon API Gateway](./lab-07-api-gateway/)
- **Focus**: RESTful APIs and microservices
- **Services**: Amazon API Gateway, API Keys, Usage Plans
- **Scenario**: Create secure APIs for customer interactions

### [Lab 8: Amazon Cognito](./lab-08-cognito/)
- **Focus**: User authentication and authorization
- **Services**: Amazon Cognito User Pools, Identity Pools
- **Scenario**: Implement customer authentication system

### [Lab 9: AWS CloudFormation](./lab-09-cloudformation/)
- **Focus**: Infrastructure as Code
- **Services**: AWS CloudFormation, CloudFormation Templates
- **Scenario**: Deploy entire infrastructure using IaC principles

### [Lab 10: Amazon CloudWatch](./lab-10-cloudwatch/)
- **Focus**: Monitoring, logging, and observability
- **Services**: Amazon CloudWatch, CloudWatch Logs, X-Ray
- **Scenario**: Monitor application performance and customer activities

## 🚀 Getting Started

Each lab is self-contained with its own README, CloudFormation templates, and implementation guides. You can complete the labs individually or follow the recommended sequence for a comprehensive learning experience.

### Prerequisites
- AWS Account with appropriate permissions
- AWS CLI installed and configured
- Basic understanding of cloud computing concepts
- Familiarity with banking/financial services concepts

### Recommended Learning Path
1. Start with Lab 1 (IAM) to establish security foundations
2. Proceed with Lab 2 (VPC) for network setup
3. Continue with Labs 3-10 in sequence for optimal learning

## 🏦 Business Context

**Scenario**: You are a cloud application developer working for Chime Bank. The bank has decided to develop and deploy a customer onboarding application on AWS. During customer onboarding, there is significant exchange of information between the bank and customers, requiring:

- **Security**: Protecting sensitive financial and personal data
- **Compliance**: Meeting banking and financial regulations
- **Scalability**: Handling varying customer onboarding volumes
- **Availability**: Ensuring 24/7 system availability
- **Performance**: Providing smooth customer experience

## 📋 Portfolio Completion Checklist

- [ ] Lab 1: IAM Security Setup
- [ ] Lab 2: VPC Network Architecture
- [ ] Lab 3: EC2 Application Hosting
- [ ] Lab 4: RDS Database Implementation
- [ ] Lab 5: S3 Storage Solutions
- [ ] Lab 6: Lambda Serverless Functions
- [ ] Lab 7: API Gateway Services
- [ ] Lab 8: Cognito Authentication
- [ ] Lab 9: CloudFormation IaC
- [ ] Lab 10: CloudWatch Monitoring

## 🔧 Technologies Used

- **Compute**: Amazon EC2, AWS Lambda
- **Storage**: Amazon S3, Amazon EBS
- **Database**: Amazon RDS
- **Networking**: Amazon VPC, Application Load Balancer
- **Security**: AWS IAM, Amazon Cognito
- **API**: Amazon API Gateway
- **Monitoring**: Amazon CloudWatch
- **Infrastructure**: AWS CloudFormation

## 📞 Support

For questions or issues with any lab, please refer to the individual lab documentation or create an issue in this repository.

---
**Note**: This portfolio is designed for educational and demonstration purposes. Ensure proper security measures and compliance requirements are met before using in production environments.
