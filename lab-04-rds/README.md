# Lab 4: Amazon Relational Database Service (RDS)

## 🎯 Objective
Set up secure and highly available customer database using Amazon RDS for the Chime Bank onboarding application.

## 🏦 Business Scenario
Implement a robust database solution to store sensitive customer information with proper backup, encryption, and high availability features required for banking applications.

## 📋 Lab Tasks

### Task 1: Create RDS Database
- Deploy PostgreSQL RDS instance
- Configure Multi-AZ deployment
- Set up automated backups

### Task 2: Implement Security
- Configure encryption at rest and in transit
- Set up VPC security groups
- Implement database parameter groups

### Task 3: Set Up Monitoring
- Configure CloudWatch monitoring
- Set up database performance insights
- Create alerting for database issues

## 🛠️ Resources Created
- **RDS Instance**: PostgreSQL Multi-AZ deployment
- **DB Subnet Group**: Spans multiple AZs
- **Security Groups**: Database access control
- **Parameter Groups**: Optimized database configuration

## 🚀 Deployment Instructions
```bash
cd lab-04-rds
./scripts/setup-rds.sh
```

## 🏁 Next Steps  
Proceed to [Lab 5: Amazon S3](../lab-05-s3/) to set up document storage.
