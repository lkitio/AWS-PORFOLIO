# Lab 5: Amazon Simple Storage Service (S3)

## 🎯 Objective
Implement secure document and media storage for customer onboarding using Amazon S3.

## 🏦 Business Scenario
Store customer documents, identity verification files, and application assets securely with proper encryption, versioning, and lifecycle management for banking compliance.

## 📋 Lab Tasks

### Task 1: Create S3 Buckets
- Create buckets for customer documents
- Configure bucket policies and ACLs
- Enable versioning and MFA delete

### Task 2: Implement Security
- Configure server-side encryption
- Set up bucket policies for restricted access
- Implement CORS for web application

### Task 3: Lifecycle Management
- Configure lifecycle policies
- Set up automated archiving
- Implement data retention policies

## 🛠️ Resources Created
- **S3 Buckets**: Customer documents, application assets
- **Bucket Policies**: Security and access control
- **Lifecycle Policies**: Automated data management
- **CloudFront Distribution**: CDN for static assets

## 🚀 Deployment Instructions
```bash
cd lab-05-s3
./scripts/setup-s3.sh
```

## 🏁 Next Steps
Proceed to [Lab 6: AWS Lambda](../lab-06-lambda/) to implement serverless functions.
