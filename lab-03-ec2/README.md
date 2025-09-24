# Lab 3: Amazon Elastic Compute Cloud (EC2)

## 🎯 Objective
Deploy scalable application servers for the Chime Bank customer onboarding application using Amazon EC2.

## 🏦 Business Scenario
Deploy the customer onboarding web application on EC2 instances with auto scaling capabilities to handle varying customer traffic loads while maintaining high availability and security.

## 📋 Lab Tasks

### Task 1: Launch EC2 Instances
- Deploy EC2 instances in private subnets
- Configure security groups and key pairs
- Install customer onboarding application

### Task 2: Set Up Auto Scaling
- Create Launch Templates
- Configure Auto Scaling Groups
- Set up scaling policies based on CPU and memory usage

### Task 3: Configure Load Balancing
- Deploy Application Load Balancer
- Configure health checks
- Set up SSL/TLS termination

### Task 4: Application Deployment
- Deploy customer onboarding application
- Configure application monitoring
- Set up deployment automation

## 🛠️ Resources Created
- **EC2 Instances**: 2-6 instances across AZs
- **Auto Scaling Group**: 1 ASG with scaling policies
- **Load Balancer**: 1 Application Load Balancer
- **Security Groups**: Web and Application tier security groups
- **Launch Template**: Template for consistent deployments

## 🚀 Deployment Instructions
```bash
cd lab-03-ec2
./scripts/setup-ec2.sh
```

## 🏁 Next Steps
Proceed to [Lab 4: Amazon RDS](../lab-04-rds/) to set up the database tier.
