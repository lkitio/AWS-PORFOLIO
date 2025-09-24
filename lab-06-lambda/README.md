# Lab 6: AWS Lambda

## 🎯 Objective
Implement serverless functions for customer data processing and workflow automation using AWS Lambda.

## 🏦 Business Scenario
Create serverless functions to process customer onboarding workflows, validate documents, send notifications, and integrate with external services for identity verification.

## 📋 Lab Tasks

### Task 1: Document Processing Functions
- Create Lambda function for document validation
- Implement image processing for ID verification
- Set up automated document classification

### Task 2: Workflow Automation
- Create functions for onboarding workflow
- Implement email/SMS notifications
- Set up integration with external APIs

### Task 3: Event-Driven Processing
- Configure S3 event triggers
- Set up SQS integration for reliable processing
- Implement error handling and retry logic

## 🛠️ Resources Created
- **Lambda Functions**: 5 functions for different processing tasks
- **Event Sources**: S3, SQS, API Gateway triggers
- **IAM Roles**: Function execution roles
- **Layers**: Shared libraries and dependencies

## 🚀 Deployment Instructions
```bash
cd lab-06-lambda
./scripts/setup-lambda.sh
```

## 🏁 Next Steps
Proceed to [Lab 7: Amazon API Gateway](../lab-07-api-gateway/) to create REST APIs.
